# Multimodal Emotion Recognition with Hyperdimensional Computing

A Haskell-based prototype for multimodal emotion classification using Hyperdimensional Computing (HDC).

## Overview

This project explores the use of high-dimensional binary hypervectors for representing and combining multiple biosignal features. The prototype simulates EEG, ECG, and GSR signals corresponding to different emotional states and uses Hyperdimensional Computing techniques to classify the resulting emotional state.

The system represents each feature using a 10,000-dimensional binary hypervector, combines the modalities using XOR binding, and compares the resulting representation with emotion prototypes using Hamming distance.

## Objective

The objective is to explore a lightweight computational approach for multimodal emotion recognition using hyperdimensional representations.

## Methodology

The system follows the following pipeline:

1. Simulate EEG, ECG, and GSR feature values.
2. Encode each feature into a 10,000-dimensional binary hypervector.
3. Fuse the three modalities using XOR-based binding.
4. Compare the fused hypervector with stored emotion prototypes.
5. Calculate Hamming distance for classification.
6. Predict the closest emotional state.
7. Maintain a short history of predictions to estimate a stable emotion.

### Processing Pipeline

EEG ──┐
      │
ECG ──┼──> Hypervector Encoding ──> XOR Fusion
      │                              │
GSR ──┘                              ↓
                              Hamming Distance
                                     ↓
                           Emotion Classification
                                     ↓
                              Emotion History

## Emotion Classes

The prototype currently considers three emotional states:

- Calm
- Stress
- Excited

## Hyperdimensional Computing

The project uses binary hypervectors with a dimensionality of 10,000.

The implementation includes:

- Random hypervector generation
- Feature encoding
- XOR binding
- Hamming-distance calculation
- Emotion prototype memory
- Prototype updating
- Prediction history

## Project Structure

```text
multimodal-emotion-hdc/
│
├── app/
│   └── Main.hs
│
├── src/
│   ├── EmotionMemory.hs
│   ├── Hypervector.hs
│   └── Lib.hs
│
├── test/
│   └── Spec.hs
│
├── README.md
├── LICENSE
├── .gitignore
├── package.yaml
├── stack.yaml
├── stack.yaml.lock
└── multimodal-emotion-hdc.cabal
