module Lib
    ( someFunc
    ) where

import Hypervector
import EmotionMemory
import System.Random
import Control.Concurrent
import Data.List (sort, group, maximumBy)
import Data.Function (on)

simulateSignal :: Emotion -> IO (Double, Double, Double)

simulateSignal Calm = do
    eeg <- randomRIO (0.2, 0.4)
    ecg <- randomRIO (0.2, 0.4)
    gsr <- randomRIO (0.2, 0.4)
    return (eeg, ecg, gsr)

simulateSignal Stress = do
    eeg <- randomRIO (0.6, 0.9)
    ecg <- randomRIO (0.7, 1.0)
    gsr <- randomRIO (0.7, 1.0)
    return (eeg, ecg, gsr)

simulateSignal Excited = do
    eeg <- randomRIO (0.5, 0.8)
    ecg <- randomRIO (0.5, 0.7)
    gsr <- randomRIO (0.6, 0.9)
    return (eeg, ecg, gsr)

-- entry point
someFunc :: IO ()
someFunc = do
    putStrLn "Emotion Recognition System Starting..."
    memory <- trainEmotionMemory
    loop memory []

mostFrequent :: [Emotion] -> Emotion
mostFrequent [] = Calm
mostFrequent xs = head $ maximumBy (compare `on` length) (group $ sort xs)

-- main loop
loop :: EmotionMemory -> [Emotion] -> IO ()
loop memory history = do

    putStr "\ESC[2J"
    putStr "\ESC[H"

    -- simulate real-valued biosignals
    rand <- randomRIO (0,2)
    let emotionType = [Calm, Stress, Excited] !! rand
    (eegFeature, ecgFeature, gsrFeature) <- simulateSignal emotionType

    
    -- encode features into hypervectors
    eeg <- encodeFeature eegFeature
    ecg <- encodeFeature ecgFeature
    gsr <- encodeFeature gsrFeature

    -- fuse signals
    let fused1 = xorHV eeg ecg
        fusedSignal = xorHV fused1 gsr

    -- compute distances
    let dCalm = hammingDistance fusedSignal (calmHV memory)
        dStress = hammingDistance fusedSignal (stressHV memory)
        dExcited = hammingDistance fusedSignal (excitedHV memory)

    -- compute confidence
    let best = minimum [dCalm, dStress, dExcited]
        dimension = 10000.0
        confidence = 1.0 - (fromIntegral best / dimension)

    -- classify emotion
    let predictedEmotion =
            if dCalm < dStress && dCalm < dExcited
                then Calm
            else if dStress < dExcited
                then Stress
            else
                Excited

    
    -- self-supervised learning
    let newMemory = updateMemory memory predictedEmotion fusedSignal

    -- emotion history (last 5)
    let newHistory = take 5 (predictedEmotion : history)

    let stableEmotion = mostFrequent newHistory

    putStrLn "==============================="
    putStrLn " Emotion Recognition System"
    putStrLn "==============================="

    putStrLn ("EEG: " ++ show eegFeature)
    putStrLn ("ECG: " ++ show ecgFeature)
    putStrLn ("GSR: " ++ show gsrFeature)

    putStrLn ("Emotion: " ++ show predictedEmotion)
    putStrLn ("Confidence: " ++ show confidence)

    putStrLn ("History: " ++ show (reverse newHistory))

    putStrLn ("Stable Emotion: " ++ show stableEmotion)

    putStrLn "==============================="

    -- wait 2 seconds
    threadDelay 2000000

    -- repeat
    loop newMemory newHistory