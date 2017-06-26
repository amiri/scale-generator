{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_scale_generator (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/amiri/scale-generator/.stack-work/install/x86_64-linux-nopie/lts-8.20/8.0.2/bin"
libdir     = "/home/amiri/scale-generator/.stack-work/install/x86_64-linux-nopie/lts-8.20/8.0.2/lib/x86_64-linux-ghc-8.0.2/scale-generator-0.1.0.0-9DuOLqujjSccPdgUqIjBo"
dynlibdir  = "/home/amiri/scale-generator/.stack-work/install/x86_64-linux-nopie/lts-8.20/8.0.2/lib/x86_64-linux-ghc-8.0.2"
datadir    = "/home/amiri/scale-generator/.stack-work/install/x86_64-linux-nopie/lts-8.20/8.0.2/share/x86_64-linux-ghc-8.0.2/scale-generator-0.1.0.0"
libexecdir = "/home/amiri/scale-generator/.stack-work/install/x86_64-linux-nopie/lts-8.20/8.0.2/libexec"
sysconfdir = "/home/amiri/scale-generator/.stack-work/install/x86_64-linux-nopie/lts-8.20/8.0.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "scale_generator_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "scale_generator_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "scale_generator_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "scale_generator_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "scale_generator_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "scale_generator_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
