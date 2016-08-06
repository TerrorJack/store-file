module Data.Store.File.ByteString (
    encodeFileWith
  , decodeFileWith
  , encodeFile
  , decodeFile
) where

import Control.Monad.Base
import Data.ByteString
import Data.Store
import Data.Store.Core
import Data.Store.Internal

encodeFileWith :: MonadBase IO m => Poke () -> Int -> FilePath -> m ()
encodeFileWith mypoke l path = liftBase $ do
    let bs = unsafeEncodeWith mypoke l
    Data.ByteString.writeFile path bs

decodeFileWith :: MonadBase IO m => Peek a -> FilePath -> m a
decodeFileWith mypeek path = liftBase $ do
    bs <- Data.ByteString.readFile path
    decodeIOWith mypeek bs

encodeFile :: (MonadBase IO m, Store a) => a -> FilePath -> m ()
encodeFile a = encodeFileWith (poke a) (getSize a)

decodeFile :: (MonadBase IO m, Store a) => FilePath -> m a
decodeFile = decodeFileWith peek
