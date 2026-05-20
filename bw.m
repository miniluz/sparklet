% eq_butterworth.m
% 6-band equalizer using 2nd-order Butterworth filters.
% Crossover frequencies are geometric means between adjacent center frequencies.
% The summed response is approximate, not guaranteed flat.

pkg load signal

fs = 48000;
f  = logspace(1, log10(fs/2), 4096);   % frequency axis, 10 Hz to Nyquist
w  = 2 * pi * f;

centers = [250, 500, 1000, 2000, 4000, 8000];

% Geometric-mean crossover frequencies between adjacent bands
xover = sqrt(centers(1:end-1) .* centers(2:end));
% xover ≈ [354, 707, 1414, 2828, 5657] Hz

H = zeros(6, length(f));

% Band 1: low-pass at xover(1)
[b, a] = butter(2, xover(1) / (fs/2), 'low');
[H_tmp, ~] = freqz(b, a, f, fs);
H(1, :) = H_tmp.';

% Bands 2–5: bandpass between adjacent crossovers
for k = 2:5
  [b, a] = butter(2, [xover(k-1), xover(k)] / (fs/2), 'bandpass');
  [H_tmp, ~] = freqz(b, a, f, fs);
  H(k, :) = H_tmp.';
end

% Band 6: high-pass at xover(5)
[b, a] = butter(2, xover(5) / (fs/2), 'high');
[H_tmp, ~] = freqz(b, a, f, fs);
H(6, :) = H_tmp.';

H_sum = sum(H, 1);

figure('Name', 'Butterworth Multiband EQ');
subplot(2, 1, 1);
  semilogx(f, 20*log10(abs(H) + eps));
  xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
  title('Individual filter responses');
  xlim([20, fs/2]); ylim([-60, 5]);
  grid on;

subplot(2, 1, 2);
  semilogx(f, 20*log10(abs(H_sum) + eps));
  xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
  title('Summed response');
  xlim([20, fs/2]); ylim([-10, 5]);
  grid on;
