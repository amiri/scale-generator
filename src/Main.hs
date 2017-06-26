{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import qualified Data.Char as C

data Interval
  = H
  | W
  deriving (Read, Show)

type IntervalSet = [Interval]

rotate :: Int -> [a] -> [a]
rotate _ [] = []
rotate n xs = zipWith const (drop n (cycle xs)) xs

ionianIntervalSet :: IntervalSet
ionianIntervalSet = [W, W, H, W, W, W, H]

dorianIntervalSet :: IntervalSet
dorianIntervalSet = rotate 1 ionianIntervalSet

phrygianIntervalSet :: IntervalSet
phrygianIntervalSet = rotate 2 ionianIntervalSet

lydianIntervalSet :: IntervalSet
lydianIntervalSet = rotate 3 ionianIntervalSet

mixolydianIntervalSet :: IntervalSet
mixolydianIntervalSet = rotate 4 ionianIntervalSet

aeolianIntervalSet :: IntervalSet
aeolianIntervalSet = rotate 5 ionianIntervalSet

locrianIntervalSet :: IntervalSet
locrianIntervalSet = rotate 6 ionianIntervalSet

majorIntervalSet :: IntervalSet
majorIntervalSet = ionianIntervalSet

minorIntervalSet :: IntervalSet
minorIntervalSet = aeolianIntervalSet

data Note =
  Note NoteLetter
       Accidental

noteLetter :: Note -> NoteLetter
noteLetter (Note n a) = n

noteAccidental :: Note -> Accidental
noteAccidental (Note n a) = a

data NoteLetter
  = A
  | B
  | C
  | D
  | E
  | F
  | G
  deriving (Read, Show, Enum, Eq, Bounded)

next :: NoteLetter -> NoteLetter
next G = A
next x = succ x

data Accidental
  = Flat
  | Sharp
  | Natural

showAccidental :: Accidental -> String
showAccidental Flat = "\x266d" :: String
showAccidental Sharp = "\x266f" :: String
showAccidental Natural = "\0" :: String

readAccidental :: String -> Accidental
readAccidental "#" = Sharp
readAccidental "b" = Flat
readAccidental _ = Natural

instance Show Accidental where
  show = showAccidental

instance Read Accidental where
  readsPrec _ a =
    let acc = a
        accidental = readAccidental acc
    in [(accidental, "")]

instance Show Note where
  show (Note n a) = show n ++ show a

addInterval :: Interval -> Note -> Note
addInterval i n = Note nextLetter newAccidental
  where
    letter = noteLetter n
    accidental = noteAccidental n
    nextLetter = next letter
    newAccidental =
      case letter of
        B ->
          case i of
            W ->
              case accidental of
                Sharp -> Sharp
                Flat -> Natural
                Natural -> Sharp
            H -> accidental
        E ->
          case i of
            W ->
              case accidental of
                Sharp -> Sharp
                Flat -> Natural
                Natural -> Sharp
            H -> accidental
        _ ->
          case i of
            W -> accidental
            H ->
              case accidental of
                Flat -> Natural
                Sharp -> Natural
                Natural -> Flat

generator :: Note -> [Interval] -> [Note]
generator n (i:is) = n' : generator n' is
  where
    n' = addInterval i n
generator n [] = []

noteInput :: IO (String, String)
noteInput = do
  putStrLn "Enter starting note for major scale: "
  letter <- getLine
  let letter' = fmap C.toUpper letter
  putStrLn "Enter accidental for starting note: "
  acc <- getLine
  return (letter', acc)

main :: IO ()
main = do
  (letter, acc) <- noteInput
  let noteLetter = read letter :: NoteLetter
  let accidental = read acc :: Accidental
  let note = Note noteLetter accidental
  let majorScaleNotes = note : generator note ionianIntervalSet
  let minorScaleNotes = note : generator note aeolianIntervalSet
  print majorScaleNotes
  print minorScaleNotes
