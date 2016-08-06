module Main (main) where

import Control.Exception (bracket)
import Control.Monad.IO.Class
import Data.ByteString
import Data.HashMap.Strict
import Data.List.Extra
import Data.Store
import Data.Store.File
import qualified Data.Store.File.ByteString as BS
import System.Directory
import System.IO
import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck
import Test.QuickCheck.Instances ()
import Test.QuickCheck.Monadic

decodeFile' :: Store a => a -> FilePath -> IO a
decodeFile' _ = decodeFile

decodeFileBS' :: Store a => a -> FilePath -> IO a
decodeFileBS' _ = BS.decodeFile

genProp :: (Eq a, Show a, Store a) => Gen a -> Property
genProp gen = monadicIO $ forAllM gen $ \a -> do
    l <- liftIO $ getTemporaryDirectory >>= \tmpdir -> bracket
        (do
            (path,handle) <- openBinaryTempFile tmpdir "store-file-test"
            hClose handle
            pure path)
        removeFile
        (\path -> do
            encodeFile a path
            aMM <- decodeFile' a path
            aMB <- decodeFileBS' a path
            BS.encodeFile a path
            aBM <- decodeFile' a path
            aBB <- decodeFileBS' a path
            pure [a,aMM,aMB,aBM,aBB])
    assert $ allSame l

spec :: Spec
spec = prop "HashMap ByteString ByteString" $ genProp (arbitrary :: Gen (HashMap ByteString ByteString))

main :: IO ()
main = hspec spec
