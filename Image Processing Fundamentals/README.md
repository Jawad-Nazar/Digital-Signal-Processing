# Compare Edge Detectors (MATLAB)

## Selected option and question
This project compares Sobel and Canny edge detection on a clean image and a reproducibly corrupted image. The question is: **How do pre-smoothing and the Canny scale parameter sigma affect edge detail and noise-related false edges?**

## Input image
- Filename: `cameraman.tif`
- Source: MATLAB sample image shipped with the Image Processing Toolbox.
- The image is loaded from MATLAB's sample-image path and is **not included** in this repository.

## Settings and procedure
- Convert image to grayscale if needed; convert to double in [0,1].
- Noisy image: `rng(42); In = imnoise(I,'gaussian',0,0.01);` (mean 0, variance 0.01).
- Sobel: `edge(imgaussfilt(image,1),'Sobel')`.
- Canny: `edge(image,'Canny',[],1)` and `edge(image,'Canny',[],3)`; empty threshold argument requests MATLAB's default threshold selection.
- Edge pixel counts: `nnz(edgeMap)`.
- MATLAB version: **fill in the version you used** (run `version` in MATLAB).
- Required toolbox: Image Processing Toolbox.

## Running
1. Open MATLAB with Image Processing Toolbox.
2. Make a new folder for this project, with a `results` subfolder.
3. Open `analysis.m` and run all sections. The script saves the figures and CSV table into `results/`.
4. For the required Live Script, open `analysis.m` in MATLAB and choose **Save As** → `analysis.mlx` (or create a Live Script and copy the sections). Run the Live Script so outputs are visible, then export it to PDF using **Export** → **PDF**. Save as `analysis.pdf` in the repository root.
5. Verify the figures and edge counts. Check the region inspection plot and write down one concrete lost or invented edge you can see. Do not claim an example you cannot verify in your own output.

## Results
The MATLAB run produces:
- `results/input_images.png`
- `results/six_edge_maps.png`
- `results/edge_pixel_counts.png`
- `results/edge_pixel_counts.csv`
- `results/region_inspection.png`

## Main conclusion (expected; confirm from your figures)
A smaller Canny sigma (1) generally preserves fine edges but can respond to noise fluctuations. A larger sigma (3) smooths more and typically reduces noise-related edge fragments, at the cost of weak or fine edges and potentially merged boundaries. Gaussian smoothing before Sobel can similarly reduce noise-triggered edges while sacrificing detail.

## Limitation
`nnz` counts how many pixels are marked as edges, but it does not assess whether they are correct. A higher count may include false edges; a lower count may reflect missed true edges. A visual inspection or comparison with ground truth is needed to assess accuracy.

## AI assistance
AI assistance was used to draft the MATLAB workflow, README, and interpretation guidance. I ran the MATLAB code, inspected the generated figures and counts, and verified/edited the conclusions before submission.

