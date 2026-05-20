% eq_linkwitz_riley.m
% 6-band equalizer using Linkwitz-Riley crossovers.
% Each LR filter = cascade of two identical 2nd-order Butterworth stages
% (giving 4th-order, -6 dB at crossover, sums to unity magnitude).

pkg load signal

fs = 48000;
f  = logspace(1, log10(fs/2), 4096);
w  = 2 * pi * f;

centers = [250, 500, 1000, 2000, 4000, 8000];
xover   = sqrt(centers(1:end-1) .* centers(2:end));

% Helper: LR4 low-pass frequency response (two cascaded Butterworth LP)
function H = lr4_lp(f, fc, fs)
  [b, a] = butter(2, fc / (fs/2), 'low');
  [H, ~] = freqz(b, a, f, fs);
  H = H .* H;   % cascade = square in frequency domain
end

% Helper: LR4 high-pass frequency response
function H = lr4_hp(f, fc, fs)
  [b, a] = butter(2, fc / (fs/2), 'high');
  [H, ~] = freqz(b, a, f, fs);
  H = H .* H;
end

H = zeros(6, length(f));

% Band 1: LR4 low-pass at xover(1)
H(1, :) = lr4_lp(f, xover(1), fs).';

% Bands 2–5: LR4 HP at lower xover × LR4 LP at upper xover
for k = 2:5
  H(k, :) = (lr4_hp(f, xover(k-1), fs) .* lr4_lp(f, xover(k), fs)).';
end

% Band 6: LR4 high-pass at xover(5)
H(6, :) = lr4_hp(f, xover(5), fs).';

H_sum = sum(H, 1);

figure('Name', 'Linkwitz-Riley Multiband EQ');
subplot(2, 1, 1);
  semilogx(f, 20*log10(abs(H) + eps));
  xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
  title('Individual LR4 band responses');
  xlim([20, fs/2]); ylim([-60, 5]);
  grid on;

subplot(2, 1, 2);
  semilogx(f, 20*log10(abs(H_sum) + eps));
  xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
  title('Summed response (should be 0 dB)');
  xlim([20, fs/2]); ylim([-3, 3]);
  grid on;
