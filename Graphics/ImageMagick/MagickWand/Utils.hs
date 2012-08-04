module Graphics.ImageMagick.MagickWand.Utils
  ( fromMBool
  , toMBool
  , withException
  , withException_
  )
  where

import           Control.Exception.Base
import           Control.Monad
import           Control.Monad.IO.Class
import           Control.Monad.Trans.Resource
import           Graphics.ImageMagick.MagickWand.FFI.Types
import           Graphics.ImageMagick.MagickWand.Types

fromMBool :: (MonadResource m) => IO MagickBooleanType -> m Bool
fromMBool = liftM (==mTrue) . liftIO
{-# INLINE fromMBool #-}
{-# DEPRECATED fromMBool "use with exception instead" #-}


withException :: (MonadResource m, ExceptionCarrier a) => a -> IO (MagickBooleanType, b) -> m b
withException a f = liftIO $ do
  (r,b) <- f
  unless (r==mTrue) $ getException a >>= throw
  return b
{-# INLINE withException #-}

withException_ :: (MonadResource m, ExceptionCarrier a) => a -> IO MagickBooleanType -> m ()
withException_ a f = liftIO $ f >>= \x -> void $ unless (x==mTrue) (getException a >>= throw)

toMBool :: Bool -> MagickBooleanType
toMBool True  = mTrue
toMBool False = mFalse
{-# INLINE toMBool #-}
