# swift-pure-json

[![Swift 5.1](https://img.shields.io/badge/Swift-5.1-blue.svg)](https://swift.org/download/)
[![github-actions](https://github.com/fabianfett/pure-swift-json/workflows/CI/badge.svg)](https://github.com/fabianfett/pure-swift-json/actions)
[![codecov](https://codecov.io/gh/fabianfett/pure-swift-json/branch/master/graph/badge.svg)](https://codecov.io/gh/fabianfett/pure-swift-json)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![tuxOS](https://img.shields.io/badge/os-tuxOS-green.svg?style=flat)

This package provides a json encoder and decoder in pure Swift (without the use of Foundation). 
The implementation shall be [RFC8259](https://tools.ietf.org/html/rfc8259) complient.


### Goals

- [x] Does not use Foundation at all
- [x] Does not use `unsafe` swift syntax
- [x] No external dependencies other than the Swift STL
- [x] Faster than Foundation implementation

### Status

**Note**: Don't use this. This is under heavy development and will be changed a lot!

Currently the focus areas are:

- This needs **a lot** of tests to ensure correct working and safety against attackers
- Fix all `preconditionFailure("unimplemented")`
- Find a way how to allow parsing of `Date` and `Data`
- Support decoding of other unicode encodings (currently only utf-8 supported)

### Alternatives

- [IkigaJSON](https://github.com/autimatisering/IkigaJSON)
- [Foundation Coding](https://github.com/apple/swift-corelibs-foundation/blob/master/Sources/Foundation/JSONEncoder.swift)
