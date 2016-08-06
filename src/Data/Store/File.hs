module Data.Store.File (
    encodeFileWith
  , decodeFileWith
  , encodeFile
  , decodeFile
) where

import Control.Monad.Base
import Data.Functor
import Data.Store
import Data.Store.Core
import Data.Store.Internal
import Foreign (castPtr)
import System.IO.MMap

encodeFileWith :: MonadBase IO m => Poke () -> Int -> FilePath -> m ()
encodeFileWith mypoke l path = liftBase $ mmapWithFilePtr path ReadWriteEx (Just (0,l)) $
    \(ptr,_) -> runPoke mypoke ptr 0 $> ()

decodeFileWith :: MonadBase IO m => Peek a -> FilePath -> m a
decodeFileWith mypeek path = liftBase $ mmapWithFilePtr path ReadOnly Nothing $
    \(ptr,sz) -> decodeIOWithFromPtr mypeek (castPtr ptr) sz

encodeFile :: (MonadBase IO m, Store a) => a -> FilePath -> m ()
encodeFile a = encodeFileWith (poke a) (getSize a)

decodeFile :: (MonadBase IO m, Store a) => FilePath -> m a
decodeFile = decodeFileWith peek
