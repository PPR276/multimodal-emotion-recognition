module Hypervector where

import qualified Data.Vector as V
import System.Random

type Hypervector = V.Vector Bool

-- Generate a random hypervector
randomHV :: Int -> IO Hypervector
randomHV dim = do
    gen <- newStdGen
    let vals = take dim (randoms gen :: [Bool])
    return $ V.fromList vals

-- XOR binding operation
xorHV :: Hypervector -> Hypervector -> Hypervector
xorHV = V.zipWith (/=)

-- Hamming distance for similarity
hammingDistance :: Hypervector -> Hypervector -> Int
hammingDistance hv1 hv2 =
    V.length $ V.filter id $ V.zipWith (/=) hv1 hv2

-- encode a real-valued feature into a hypervector
encodeFeature :: Double -> IO Hypervector
encodeFeature value = do
    base <- randomHV 10000
    if value > 0.5
        then return base
        else return (V.map not base)