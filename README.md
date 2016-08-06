# store-file

[![Build Status](https://travis-ci.org/TerrorJack/store-file.svg)](https://travis-ci.org/TerrorJack/store-file)
[![Build status](https://ci.appveyor.com/api/projects/status/github/TerrorJack/store-file?svg=true)](https://ci.appveyor.com/project/TerrorJack/store-file)
[![Hackage](https://img.shields.io/hackage/v/store-file.svg)](https://github.com/TerrorJack/store-file)
[![store-file on Stackage Nightly](https://www.stackage.org/package/store-file/badge/nightly)](https://www.stackage.org/nightly/package/store-file)

Utilities for running `Peek`/`Poke` operations of `store` on files. Two implementations are provided:

* `Data.Store.File`: the default implementation based on `mmap`
* `Data.Store.File.ByteString`: based on strict `ByteString`

There is also a test-suite and a benchmark, which creates random `HashMap ByteString ByteString`s and runs the operations on temporary files.
