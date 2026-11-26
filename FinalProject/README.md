# Tire Classification: Image Processing, Motion Blur and Restoration

## 1. Introduction

This project investigates the effects of image preprocessing, motion blur and image restoration on tire classification using traditional image processing methods and a pretrained YOLO classification model.

The dataset contains 500 tire images: 250 studded tires and 250 non-studded tires. The experiments use the provided dataset and pretrained YOLO model without training a new model.

## 2. Objectives

- Apply traditional image preprocessing techniques.
- Evaluate the pretrained YOLO classifier on original images.
- Simulate horizontal motion blur.
- Apply Wiener restoration to blurred images.
- Compare classification performance before and after degradation and restoration.

## 3. Dataset

The dataset contains two classes:

- `st` – Studded tires
- `nst` – Non-studded tires

The dataset was divided into training, validation and testing sets. The test set contained 74 images: 37 studded and 37 non-studded.

The original dataset and model files are not included in this repository.

## 4. Traditional Image Processing

The following operations were applied to representative images from both classes:

1. Grayscale conversion
2. CLAHE contrast enhancement
3. Gaussian filtering
4. Binary thresholding
5. Canny edge detection
6. Morphological opening

These techniques demonstrate how image contrast, noise, edges and tire patterns can be modified. Traditional preprocessing can highlight visual features, but it cannot reliably distinguish tire classes on its own because reflections, shadows and tread patterns may produce similar characteristics.

## 5. YOLO Baseline

The pretrained YOLO classification model was evaluated using the original test images.

| Metric | Result |
|---|---:|
| Accuracy | 90.54% |
| Precision | 84.09% |
| Recall | 100.00% |
| F1-score | 91.36% |

The baseline model correctly classified 67 out of 74 test images. Recall for studded tires was 100%, although some non-studded tires were incorrectly classified as studded.

## 6. Motion Blur

Horizontal motion blur was simulated using a 15 × 15 kernel.

The blurred images showed reduced sharpness and less visible tread details, wheel spokes and smaller image features. The degradation negatively affected classification performance.

## 7. Wiener Restoration

Wiener restoration was applied to the motion-blurred images using the same motion blur kernel.

The restored images showed partial improvement in sharpness and tread visibility. However, some blur remained, and restoration artifacts were visible. The original information was not completely recovered.

## 8. YOLO Performance Comparison

| Experiment | Accuracy | Precision | Recall | F1-score |
|---|---:|---:|---:|---:|
| Original images | 90.54% | 84.09% | 100.00% | 91.36% |
| Motion-blurred images | 70.27% | 82.61% | 51.35% | 63.33% |
| Wiener-restored images | 72.97% | 77.42% | 64.86% | 70.59% |

Motion blur reduced accuracy by 20.27 percentage points compared with the original images. Wiener restoration improved accuracy by 2.70 percentage points compared with the blurred images.

Restoration improved recall, but precision decreased. This indicates that restoration helped identify more studded tires but also increased false positive predictions.

## 9. Discussion and Conclusion

Traditional image processing techniques are simple, fast and interpretable. Grayscale conversion, CLAHE, Gaussian filtering and edge detection can help highlight image characteristics. However, these techniques cannot reliably distinguish studded and non-studded tires by themselves because bright regions, shadows and tread patterns can produce similar features.

The pretrained YOLO model achieved 90.54% accuracy on the original test images. Motion blur reduced accuracy to 70.27%, demonstrating that image degradation can significantly affect classification. Wiener restoration increased accuracy to 72.97%, showing a partial improvement, but it did not recover the original performance.

For a practical tire classification application, YOLO would be preferred as the main classifier because it can learn complex visual features. Image quality control and suitable preprocessing may help improve reliability. Restoration should be evaluated using classification metrics rather than visual quality alone.

## 10. Limitations

The evaluation used a limited test set of 74 images. Motion blur was simulated using a fixed kernel, which may not represent real-world camera movement. Wiener restoration cannot completely recover information lost through degradation, and its results depend on the assumed blur kernel.

## 11. Environment and Reproducibility

- Python
- Google Colab
- OpenCV
- Ultralytics YOLO
- scikit-learn
- NumPy
- Matplotlib

To reproduce the experiments:

1. Open the notebook in Google Colab.
2. Upload the provided dataset and pretrained YOLO model.
3. Install the required libraries.
4. Run the notebook cells in order.

## 12. AI Assistance

AI tools were used to assist with coding, troubleshooting, explaining image processing concepts and organizing the experimental results. All experiments were executed in Google Colab, and the reported metrics are based on the actual experimental outputs.

