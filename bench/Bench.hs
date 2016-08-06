module Main (main) where

import Control.DeepSeq
import Control.Exception
import Control.Monad
import Criterion.Main
import Data.ByteString
import Data.Store
import Data.Store.File
import qualified Data.Store.File.ByteString as BS
import Data.HashMap.Strict
import System.Directory
import System.IO
import Test.QuickCheck
import Test.QuickCheck.Instances ()

decodeFile' :: Store a => a -> FilePath -> IO a
decodeFile' _ = decodeFile

decodeFileBS' :: Store a => a -> FilePath -> IO a
decodeFileBS' _ = BS.decodeFile

encodeFileMMapBench :: Store a => a -> FilePath -> Benchmarkable
encodeFileMMapBench a path = whnfIO $ encodeFile a path

decodeFileMMapBench :: Store a => a -> FilePath -> Benchmarkable
decodeFileMMapBench a path = whnfIO $ decodeFile' a path

encodeFileByteStringBench :: Store a => a -> FilePath -> Benchmarkable
encodeFileByteStringBench a path = whnfIO $ BS.encodeFile a path

decodeFileByteStringBench :: Store a => a -> FilePath -> Benchmarkable
decodeFileByteStringBench a path = whnfIO $ decodeFileBS' a path

prepBench :: Int -> IO (HashMap ByteString ByteString, FilePath)
prepBench sz = do
    a <- generate $ fromList <$> replicateM sz arbitrary
    tmpdir <- getTemporaryDirectory
    (path,hdl) <- openBinaryTempFile tmpdir "store-file-bench"
    hClose hdl
    deepseq a $ pure (a,path)

makeBench :: (HashMap ByteString ByteString, FilePath) -> Benchmark
makeBench (a,path) = bgroup "Benchmark" [
    bgroup "Poke" [
        bench "MMap Poke" $ encodeFileMMapBench a path
      , bench "ByteString Poke" $ encodeFileByteStringBench a path
    ]
  , bgroup "Peek" [
        bench "MMap Peek" $ decodeFileMMapBench a path
      , bench "ByteString Peek" $ decodeFileByteStringBench a path
    ]
  ]

main :: IO ()
main = bracket (prepBench 1000000) (\(_,path) -> removeFile path) (\t -> defaultMain [makeBench t])
