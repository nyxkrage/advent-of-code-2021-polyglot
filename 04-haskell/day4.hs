{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import System.IO
import Control.Monad
import Data.List

splitBy delimiter = foldr f [[]]
            where f c l@(x:xs) | c == delimiter = []:l
                             | otherwise = (c:x):xs

splitEvery _ [] = []
splitEvery n list = first : splitEvery n rest
  where
    (first,rest) = splitAt n list


boardToFields :: [String] -> [String]
boardToFields = fmap join (map (splitBy ' '))

clearEmpties :: [String] -> [String]
clearEmpties = filter (/= "")

isBingo :: [Integer] -> Bool
isBingo board = any (all (== -1)) (splitEvery 5 board) || any (\c -> all (\r -> board!!(r * 5 + c) == -1) [0..4]) [0..4]

change :: Eq a => a -> a -> [a] -> [a]
change org new = map (\h -> if h == org then new else h)

slice :: Int -> Int -> [a] -> [a]
slice from to xs = take (to - from + 1) (drop from xs)

updateBoard1 :: Int -> [Integer] -> [Integer] -> [Integer]
updateBoard1 numBoards numbers boards = do
    let bingoIndex = findIndex (\i -> isBingo (slice (i * 25) ((i + 1) * 25 - 1) boards)) [0..numBoards - 1]
    case bingoIndex of
        Just i -> [sum (change (-1) 0 (slice (i * 25) ((i + 1) * 25 - 1) boards)) * head numbers]
        Nothing -> updateBoard1 numBoards (tail numbers) (change (numbers!!1) (-1) boards)

updateBoard2 :: [Int] -> [Integer] -> [Integer] -> [Integer]
updateBoard2 remaining numbers boards = do
    let boardsLeft = filter (\i -> not (isBingo (slice (i * 25) ((i + 1) * 25 - 1) boards))) remaining
    if null boardsLeft
    then [sum (change (-1) 0 (slice (head remaining * 25) ((head remaining + 1) * 25 - 1) boards)) * head numbers]
    else updateBoard2 boardsLeft (tail numbers) (change (numbers!!1) (-1) boards)

main :: IO ()
main = do
    content <- readFile"input"
    let input = lines content
    let numbers = map read (splitBy ',' (head input)) :: [Integer]

    let boards = map read (clearEmpties (boardToFields (filter (/= "") (drop 2 input)))) :: [Integer]
    let boardCount = div (length boards) 25
    print (updateBoard1 boardCount numbers (change (head numbers) (-1) boards))
    print (updateBoard2 [0..(boardCount - 1)]  numbers (change (head numbers) (-1) boards))

