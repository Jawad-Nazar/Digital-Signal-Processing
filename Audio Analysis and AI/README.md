# Environmental Sound Analysis

## Selected option and question
Selected option: C
Selected sound: **rain** (`rain.wav`).

Other supplied filenames: `clock.wav`, `dog.wav`, and `fire.wav`. The assignment requires analysing only one option.

## Audio and preprocessing
- Selected file: `rain.wav`
- Original sample rate: 44,100 Hz
- Duration: 5.00 seconds
- Mono recording
- Resampled to 16,000 Hz using `scipy.signal.resample_poly`
- Normalized to peak amplitude 1 for plotting

## Analysis settings
- Sample rate: 16,000 Hz
- STFT window lengths: 512 samples (32 ms) and 2048 samples (128 ms)
- Hop length: 160 samples (10 ms), used for both
- Window function: Hann
- Spectrogram frequency range shown: 0–8,000 Hz
- Focused interval: 2.0–2.5 seconds
- Focused frequency region: 1,000–6,000 Hz

## Main observations
The rain recording is continuous and noise-like, with amplitude fluctuations over the five-second clip. The selected interval (2.0–2.5 s) has a normalized RMS of about 0.1455, compared with about 0.1247 for 0.0–1.0 s.

The 512-sample window is 32 ms long and has frequency-bin spacing 31.25 Hz, giving better temporal localization but coarser frequency resolution. The 2048-sample window is 128 ms long and has frequency-bin spacing 7.8125 Hz, giving finer frequency resolution but smearing short events over a longer time. This demonstrates the STFT time-frequency resolution trade-off.

## Limitation
A longer window improves frequency resolution at the expense of time localization, so the STFT cannot optimize both at once. This is only a five-second recording and one interval was inspected; the findings may not generalize to all rain recordings.

## Run the notebook
1. Download/clone this project.
2. Install dependencies:
   ```bash
   pip install numpy scipy matplotlib soundfile jupyter
   ```
3. Keep the selected recording in `audio/rain.wav` (or beside the notebook).
4. Open `analysis.ipynb` in Jupyter Notebook or JupyterLab.
5. Choose **Run All**. The notebook includes executed outputs and generates figures under `results/`.

## Contents
- `analysis.ipynb`: executed notebook with code, figures, and explanation.
- `results/waveform.png`: waveform.
- `results/frequency_spectrum.png`: average frequency spectrum.
- `results/spectrogram_comparison.png`: 512 vs 2048 spectrograms.
- `results/selected_region.png`: selected interval and frequency region.
- `results/recording_choice_waveforms.png`: quick visual overview of the four supplied clips.
- `audio/rain.wav`: selected course audio, included for reproducibility (check attribution/licensing before public upload).

## AI assistance
AI assistance was used to help organize the notebook and explain signal-processing concepts. The notebook was run, and the outputs and observations were based on the supplied recording.

