module EmotionMemory
    ( Emotion(..)
    , EmotionMemory(..)
    , trainEmotionMemory
    , updateMemory
    ) where

import Hypervector

data Emotion
    = Calm
    | Stress
    | Excited
    deriving (Show, Eq, Ord)

-- emotion prototype memory
data EmotionMemory = EmotionMemory
    { calmHV :: Hypervector
    , stressHV :: Hypervector
    , excitedHV :: Hypervector
    }

-- create a random memory (initial training)
trainEmotionMemory :: IO EmotionMemory
trainEmotionMemory = do
    calm <- randomHV 10000
    stress <- randomHV 10000
    excited <- randomHV 10000
    return (EmotionMemory calm stress excited)

updateMemory :: EmotionMemory -> Emotion -> Hypervector -> EmotionMemory
updateMemory memory emotion signal =
    case emotion of
        Calm ->
            memory { calmHV = xorHV (calmHV memory) signal }

        Stress ->
            memory { stressHV = xorHV (stressHV memory) signal }

        Excited ->
            memory { excitedHV = xorHV (excitedHV memory) signal }