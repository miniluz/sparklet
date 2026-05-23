import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np
from styles_config import (
    LINE_WIDTH,
    apply_style,
)

apply_style()

FIG_WIDTH = 8
FIG_HEIGHT = 5

FS = 48000
Q31_MAX = 2**31 - 1
Q31_MIN = -(2**31)
Q31_SCALE = 2**31

# ---------------------------------------------------------------------------
# Filter definition
# ---------------------------------------------------------------------------
# Five first-order IIR lowpass stages as degenerate Q31 biquads:
#
#   H(z) = b0 / (1 - (1-α)·z⁻¹)
#
# Coefficient layout: [b0, 0, b1, b2, a1, a2]
#   b0 = round(α · 2³¹)
#   a1 = -round((1-α) · 2³¹)   stored negative; engine computes acc += a1*y1
#   b1 = b2 = a2 = 0
#
# Band structure — difference of adjacent LP stage outputs (Option A):
#   Band 0: input  − LP0   →  HP  > ~1500 Hz
#   Band 1: LP0    − LP1   →  BP   750–1500 Hz
#   Band 2: LP1    − LP2   →  BP   375–750  Hz
#   Band 3: LP2    − LP3   →  BP   187–375  Hz
#   Band 4: LP3    − LP4   →  BP    93–187  Hz
#   Band 5: LP4           →  LP  <  ~93 Hz

ALPHAS = [1 / 16, 1 / 32, 1 / 64, 1 / 128, 1 / 256]
POST_SHIFT = 0

BAND_GAINS = [0.5, 1.0, 0.5, 1.0, 0.5, 1.0]

BAND_LABELS = [
    "HP >~1500 Hz (×0.5)",
    "BP 750–1500 Hz",
    "BP 375–750 Hz (×0.5)",
    "BP 187–375 Hz",
    "BP 93–187 Hz (×0.5)",
    "LP <~93 Hz",
]

BAND_COLORS = [
    "#4E79A7",
    "#F28E2B",
    "#E15759",
    "#76B7B2",
    "#59A14F",
    "#B07AA1",
]
COMBINED_COLOR = "#333333"


# ---------------------------------------------------------------------------
# Coefficient generation
# ---------------------------------------------------------------------------
def lp_biquad_coeffs_q31(alpha: float) -> list[int]:
    b0 = int(round(alpha * Q31_SCALE))
    a1 = int(round((1.0 - alpha) * Q31_SCALE))  # positive: engine adds a1*y1
    return [b0, 0, 0, 0, a1, 0]


LP_COEFFS = [lp_biquad_coeffs_q31(a) for a in ALPHAS]


# ---------------------------------------------------------------------------
# Biquad engine (Q31)
# ---------------------------------------------------------------------------
def apply_biquad_q31(x: np.ndarray, coeffs: list) -> np.ndarray:
    b0, _pad, b1, b2, a1, a2 = [int(c) for c in coeffs]
    n = len(x)
    y = np.zeros(n, dtype=np.int64)
    x1 = x2 = y1 = y2 = np.int64(0)

    for i in range(n):
        xn = np.int64(x[i])
        acc = b0 * xn + b1 * x1 + b2 * x2 + a1 * y1 + a2 * y2
        yn = np.int64(np.clip(acc >> 31, Q31_MIN, Q31_MAX))
        y[i] = yn
        x2, x1 = x1, xn
        y2, y1 = y1, yn

    return y


# ---------------------------------------------------------------------------
# Single-pass LP cascade — computes all stage outputs in one traversal
# ---------------------------------------------------------------------------
def run_lp_cascade_all(x: np.ndarray) -> list[np.ndarray]:
    """
    Returns a list of 5 arrays [LP0, LP1, LP2, LP3, LP4],
    each being the output of the cumulative cascade to that depth.
    Input and all intermediates share the same sample count.
    """
    stages = []
    out = x
    for coeffs in LP_COEFFS:
        out = apply_biquad_q31(out, coeffs)
        stages.append(out)
    return stages


# ---------------------------------------------------------------------------
# Swept-sine frequency response — all bands in one sweep
# ---------------------------------------------------------------------------
def frequency_response_all_bands(
    n_freqs: int = 512,
    n_periods: int = 30,
    input_amplitude: int = 2**28,  # well below Q31 full-scale to avoid clipping
) -> tuple[np.ndarray, list[np.ndarray]]:
    freqs = np.logspace(np.log10(20), np.log10(FS / 2 - 1), n_freqs)
    magnitudes = [np.zeros(n_freqs) for _ in range(6)]

    for k, f in enumerate(freqs):
        samples_per_period = max(int(FS / f), 2)
        n_samples = n_periods * samples_per_period

        t = np.arange(n_samples) / FS
        x = np.clip(
            np.round(input_amplitude * np.sin(2 * np.pi * f * t)),
            Q31_MIN,
            Q31_MAX,
        ).astype(np.int64)

        # Single cascade pass — all stage outputs at once
        stages = run_lp_cascade_all(x)

        # Assemble bands by subtraction; no cascade recomputation
        bands_raw = [
            x - stages[0],  # Band 0: HP
            stages[0] - stages[1],  # Band 1: BP
            stages[1] - stages[2],  # Band 2: BP
            stages[2] - stages[3],  # Band 3: BP
            stages[3] - stages[4],  # Band 4: BP
            stages[4],  # Band 5: LP
        ]

        ss_start = n_samples // 2
        for b, (band_raw, gain) in enumerate(zip(bands_raw, BAND_GAINS)):
            band_scaled = np.clip(
                np.round(band_raw.astype(np.float64) * gain),
                Q31_MIN,
                Q31_MAX,
            ).astype(np.int64)

            output_amplitude = np.max(np.abs(band_scaled[ss_start:]))
            gain_lin = (
                output_amplitude / input_amplitude if output_amplitude > 0 else 1e-9
            )
            magnitudes[b][k] = 20 * np.log10(max(gain_lin, 1e-9))

    return freqs, magnitudes


def compute_combined_response(freqs: np.ndarray, all_magnitudes: list) -> np.ndarray:
    linear_sum = np.zeros(len(freqs))
    for mag_db in all_magnitudes:
        linear_sum += 10 ** (mag_db / 20)
    return 20 * np.log10(np.maximum(linear_sum, 1e-9))


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    print("Computing frequency responses (swept-sine, Q31 biquad LP cascade)...")
    freqs, all_magnitudes = frequency_response_all_bands()

    combined_mag = compute_combined_response(freqs, all_magnitudes)

    fig, ax = plt.subplots(figsize=(FIG_WIDTH, FIG_HEIGHT))

    for i, label in enumerate(BAND_LABELS):
        ax.semilogx(
            freqs,
            all_magnitudes[i],
            color=BAND_COLORS[i],
            linewidth=LINE_WIDTH,
            label=label,
            alpha=0.85,
        )

    ax.semilogx(
        freqs,
        combined_mag,
        color=COMBINED_COLOR,
        linewidth=LINE_WIDTH * 1.4,
        linestyle="--",
        label="Combinado (suma de las bandas)",
        alpha=1.0,
    )

    ax.set_xlim(20, FS / 2)
    ax.set_ylim(-60, 10)
    ax.set_xlabel("Frecuencia (Hz)")
    ax.set_ylabel("Ganancia (dB)")
    ax.set_title("Respuesta espectral del banco de filtros")

    ax.xaxis.set_major_formatter(
        ticker.FuncFormatter(lambda x, _: f"{int(x):,}".replace(",", "."))
    )
    ax.xaxis.set_major_locator(ticker.LogLocator(base=10, subs=[1, 2, 5], numticks=12))
    ax.xaxis.set_minor_locator(ticker.NullLocator())

    ax.legend(fontsize=8, loc="lower right")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    plt.tight_layout(pad=1.5)

    # os.makedirs(OUTPUT_DIR, exist_ok=True)
    # out_path = os.path.join(OUTPUT_DIR, "octave_filter_response_q15.png")
    # fig.savefig(
    #     out_path, dpi=DPI, bbox_inches="tight", facecolor="white", edgecolor="none"
    # )
    # print(f"Saved: {out_path}")
    plt.show()


if __name__ == "__main__":
    main()
