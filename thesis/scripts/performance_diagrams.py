import os

import matplotlib.pyplot as plt
import numpy as np
from styles_config import DPI, OUTPUT_DIR, apply_style

apply_style()

# Figure dimensions
FIG_WIDTH = 6.5
FIG_HEIGHT = 5

bar_width = 0.6
gap_bars = 0.1
gap_groups = 0.3

first_bar = 0
second_bar = first_bar + bar_width + gap_bars
third_bar = second_bar + bar_width + gap_groups
fourth_bar = third_bar + bar_width + gap_bars

x_left = [first_bar, second_bar]
x_right = [third_bar, fourth_bar]

data_12_eq_no_conf = [857, 850, 855, 860, 855]
data_8_eq_no_conf = [553, 553, 562, 561, 554]
data_8_eq_no_conf_rust = [713, 714, 713, 712]
data_12_no_eq_conf = [789, 795, 796, 789, 792]
data_8_no_eq_conf = [515, 519, 514, 523, 514, 517]
data_12_no_eq_no_conf = [768, 770, 770, 770, 769, 769, 770]
data_8_no_eq_no_conf = [511, 513, 519, 513, 512, 520]
data_8_no_eq_no_conf_rust = [610, 605, 605, 605, 605]

avg_12_eq_no_conf = np.mean(data_12_eq_no_conf)
avg_8_eq_no_conf = np.mean(data_8_eq_no_conf)
avg_8_eq_no_conf_rust = np.mean(data_8_eq_no_conf_rust)
avg_12_no_eq_conf = np.mean(data_12_no_eq_conf)
avg_8_no_eq_conf = np.mean(data_8_no_eq_conf)
avg_12_no_eq_no_conf = np.mean(data_12_no_eq_no_conf)
avg_8_no_eq_no_conf = np.mean(data_8_no_eq_no_conf)
avg_8_no_eq_no_conf_rust = np.mean(data_8_no_eq_no_conf_rust)


COLOR_ORANGE = "#ff902e"
COLOR_ORANGE_LIGHT = "#ffb22e"
COLOR_BLUE = "#3f58d4"
COLOR_BLUE_LIGHT = "#3f80d4"


def create_bar_chart_figure1():
    fig, ax = plt.subplots(figsize=(FIG_WIDTH, FIG_HEIGHT))

    values_12 = [avg_12_eq_no_conf, avg_12_no_eq_no_conf]  # Con EQ, Sin EQ
    values_8 = [avg_8_eq_no_conf, avg_8_no_eq_no_conf]  # Con EQ, Sin EQ

    ax.axhline(
        y=1000,
        color="#AA4444",
        linestyle="--",
        linewidth=1.5,
        label="Tiempo máximo",
        zorder=3,
    )

    bars_12 = ax.bar(
        x_left,
        values_12,
        color=[COLOR_ORANGE, COLOR_ORANGE_LIGHT],
        width=0.6,
        edgecolor="none",
        zorder=2,
    )
    bars_8 = ax.bar(
        x_right,
        values_8,
        color=[COLOR_BLUE, COLOR_BLUE_LIGHT],
        width=0.6,
        edgecolor="none",
        zorder=2,
    )

    # Etiquetas de las barras
    labels_left = ["Con EQ", "Sin EQ"]
    labels_right = ["Con EQ", "Sin EQ"]

    for bar, label in zip(bars_12, labels_left):
        height = bar.get_height()
        ax.annotate(
            f"{label}\n{height:.0f} μs",
            xy=(bar.get_x() + bar.get_width() / 2, height),
            xytext=(0, 3),
            textcoords="offset points",
            ha="center",
            va="bottom",
            fontsize=9,
        )

    for bar, label in zip(bars_8, labels_right):
        height = bar.get_height()
        ax.annotate(
            f"{label}\n{height:.0f} μs",
            xy=(bar.get_x() + bar.get_width() / 2, height),
            xytext=(0, 3),
            textcoords="offset points",
            ha="center",
            va="bottom",
            fontsize=9,
        )

    ax.set_ylabel("Duración (μs)")
    ax.set_title(
        "Duración del renderizado de un bloque de audio de 1ms\nincluyendo y sin incluir el ecualizador"
    )
    ax.set_xticks([(x_left[0] + x_left[1]) / 2, (x_right[0] + x_right[1]) / 2])
    ax.set_xticklabels(["12 voces", "8 voces"])
    ax.set_ylim(0, 1099)

    ax.legend(loc="upper right", framealpha=0.9)

    plt.tight_layout()
    return fig


def create_bar_chart_figure2():
    fig, ax = plt.subplots(figsize=(FIG_WIDTH, FIG_HEIGHT))

    values_12 = [
        avg_12_no_eq_conf,
        avg_12_no_eq_no_conf,
    ]  # Configurable, No configurable
    values_8 = [avg_8_no_eq_conf, avg_8_no_eq_no_conf]  # Configurable, No configurable

    ax.axhline(
        y=1000,
        color="#AA4444",
        linestyle="--",
        linewidth=1.5,
        label="Tiempo máximo",
        zorder=3,
    )

    bars_12 = ax.bar(
        x_left,
        values_12,
        color=[COLOR_ORANGE, COLOR_ORANGE_LIGHT],
        width=0.6,
        edgecolor="none",
        zorder=2,
    )
    bars_8 = ax.bar(
        x_right,
        values_8,
        color=[COLOR_BLUE, COLOR_BLUE_LIGHT],
        width=0.6,
        edgecolor="none",
        zorder=2,
    )

    labels_left = ["Con conf.", "Sin conf."]
    labels_right = ["Con conf.", "Sin conf."]

    for bar, label in zip(bars_12, labels_left):
        height = bar.get_height()
        ax.annotate(
            f"{label}\n{height:.0f} μs",
            xy=(bar.get_x() + bar.get_width() / 2, height),
            xytext=(0, 3),
            textcoords="offset points",
            ha="center",
            va="bottom",
            fontsize=9,
        )

    for bar, label in zip(bars_8, labels_right):
        height = bar.get_height()
        ax.annotate(
            f"{label}\n{height:.0f} μs",
            xy=(bar.get_x() + bar.get_width() / 2, height),
            xytext=(0, 3),
            textcoords="offset points",
            ha="center",
            va="bottom",
            fontsize=9,
        )

    ax.set_ylabel("Duración (μs)")
    ax.set_title(
        "Duración del renderizado de un bloque de audio de 1ms\nincluyendo y sin incluir la configurabilidad en ejecución"
    )
    ax.set_xticks([(x_left[0] + x_left[1]) / 2, (x_right[0] + x_right[1]) / 2])
    ax.set_xticklabels(["12 voces", "8 voces"])
    ax.set_ylim(0, 1099)

    ax.legend(loc="upper right", framealpha=0.9)

    plt.tight_layout()
    return fig


def create_bar_chart_figure3():
    fig, ax = plt.subplots(figsize=(FIG_WIDTH, FIG_HEIGHT))

    values_12 = [
        avg_8_eq_no_conf_rust,
        avg_8_eq_no_conf,
    ]  # Sin CMSIS-DSP, con CMSIS-DSP
    values_8 = [
        avg_8_no_eq_no_conf_rust,
        avg_8_no_eq_conf,
    ]  # Sin CMSIS-DSP, con CMSIS-DSP

    bars_12 = ax.bar(
        x_left,
        values_12,
        color=[COLOR_ORANGE, COLOR_ORANGE_LIGHT],
        width=0.6,
        edgecolor="none",
        zorder=2,
    )
    bars_8 = ax.bar(
        x_right,
        values_8,
        color=[COLOR_BLUE, COLOR_BLUE_LIGHT],
        width=0.6,
        edgecolor="none",
        zorder=2,
    )

    # Etiquetas de las barras
    labels_left = ["Sin CMSIS-DSP", "Con CMSIS-DSP"]
    labels_right = ["Sin CMSIS-DSP", "Con CMSIS-DSP"]

    for bar, label in zip(bars_12, labels_left):
        height = bar.get_height()
        ax.annotate(
            f"{label}\n{height:.0f} μs",
            xy=(bar.get_x() + bar.get_width() / 2, height),
            xytext=(0, 3),
            textcoords="offset points",
            ha="center",
            va="bottom",
            fontsize=9,
        )

    for bar, label in zip(bars_8, labels_right):
        height = bar.get_height()
        ax.annotate(
            f"{label}\n{height:.0f} μs",
            xy=(bar.get_x() + bar.get_width() / 2, height),
            xytext=(0, 3),
            textcoords="offset points",
            ha="center",
            va="bottom",
            fontsize=9,
        )

    ax.set_ylabel("Duración (μs)")
    ax.set_title(
        "Duración del renderizado de un bloque de audio de 1ms\nusando y sin usar CMSIS-DSP"
    )
    ax.set_xticks([(x_left[0] + x_left[1]) / 2, (x_right[0] + x_right[1]) / 2])
    ax.set_xticklabels(["Con el ecualizador", "Sin el ecualizador"])
    ax.set_ylim(0, 899)

    plt.tight_layout()
    return fig


def save_figure(fig, filename):
    """Save figure to output directory."""
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    filepath = os.path.join(OUTPUT_DIR, filename)
    fig.savefig(
        filepath, dpi=DPI, bbox_inches="tight", facecolor="white", edgecolor="none"
    )
    print(f"Saved: {filepath}")
    plt.close(fig)


if __name__ == "__main__":
    fig1 = create_bar_chart_figure1()
    save_figure(fig1, "con_vs_sin_eq.png")

    fig2 = create_bar_chart_figure2()
    save_figure(fig2, "con_vs_sin_conf.png")

    fig3 = create_bar_chart_figure3()
    save_figure(fig3, "con_vs_sin_cmsis.png")
