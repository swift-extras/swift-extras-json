# pure-swift-json

[![Swift 5.1](https://img.shields.io/badge/Swift-5.1-blue.svg)](https://swift.org/download/)
[![github-actions](https://github.com/fabianfett/pure-swift-json/workflows/CI/badge.svg)](https://github.com/fabianfett/pure-swift-json/actions)
[![codecov](https://codecov.io/gh/fabianfett/pure-swift-json/branch/master/graph/badge.svg)](https://codecov.io/gh/fabianfett/pure-swift-json)

This package provides a json encoder and decoder in pure Swift (without the use of Foundation or any other dependency). 
The implementation is [RFC8259](https://tools.ietf.org/html/rfc8259) complient. It offers a significant performance improvement over the Foundation implementation on Linux.

If you like the idea of using pure Swift without any dependencies you might also like my reimplementation of Base64 in pure Swift: [`swift-base64-kit`](https://github.com/fabianfett/swift-base64-kit)

‼️ **NOTE:** This is in a very early stage of development. Please take into account that the API might change while in prerelease.

## Goals

- [x] Does not use Foundation at all
- [x] Does not use `unsafe` Swift syntax
- [x] No external dependencies other than the Swift STL
- [x] Faster than Foundation implementation

#### Currently not supported

- custom encoder and decoder for [ `Data` and `Date`](#what-about-date-and-data)
- parsing/decoding of [UTF-16 and UTF-32 encoded json](#utf-16-and-utf-32)
- transform CodingKeys to camelCase or snake_case (I want to look into this)

#### Alternatives

- [IkigaJSON](https://github.com/autimatisering/IkigaJSON) Super fast encoding and decoding especially for server side Swift code. Depends on `SwiftNIO`.
- [Foundation Coding](https://github.com/apple/swift-corelibs-foundation/blob/master/Sources/Foundation/JSONEncoder.swift)

## Usage

Add `pure-swift-json` as dependency to your `Package.swift`:

```swift
  dependencies: [
    .package(url: "https://github.com/fabianfett/pure-swift-json.git", .upToNextMajore(from: "0.1.0")),
  ],
```

Add `PureSwiftJSONCoding` to the target you want to use it in.

```swift
  targets: [
    .target(
      name: "MyFancyTarget",
      dependencies: ["PureSwiftJSONCoding"]),
  ]
```

Use it as you would use the Foundation encoder and decoder.

```swift
import PureSwiftJSONCoding

let bytesArray  = try JSONEncoder().encode(myEncodable)
let myDecodable = try JSONDecoder().decode(MyDecodable.self, from: bytes)
```

## Performance

All tests have been run on a 2019 MacBook Pro (16" – 2,4 GHz 8-Core Intel Core i9). You can run the tests yourself
by cloning this repo and

```bash
# change dir to perf tests
$ cd PerfTests

# compile in release mode - IMPORTANT ‼️
$ swift build -c release

# run tests
$ .build/release/PureSwiftJSONCodingPerfTests
```

#### Encoding

|  | macOS Swift 5.1 | macOS Swift 5.2 | Linux Swift 5.1 | Linux Swift 5.2 |
|:--|:--|:--|:--|:--|
| Foundation   | 2.61s | 2.62s | 13.03s | 12.52s |
| PureSwiftJSON | 1.23s | 1.25s | 1.13s | 1.05s |
| Speedup | ~2x | ~2x | **~10x** | **~10x** |


#### Decoding

|  | macOS Swift 5.1 | macOS Swift 5.2 | Linux Swift 5.1 | Linux Swift 5.2 |
|:--|:--|:--|:--|:--|
| Foundation   | 2.72s | 3.04s | 10.27s | 10.65s |
| PureSwiftJSON | 1.70s | 1.72s | 1.39s | 1.16s |
| Speedup | ~1.5x | ~1.5x | **~7x** | **~8x** |

## Workarounds

### What about `Date` and `Data`?

Date and Data are special cases for encoding and decoding. They do have default implementations that are kind off special:

- Date will be encoded as a float

    Example: `2020-03-17 16:36:58 +0000` will be encoded as `606155818.503831`
    
- Data will be encoded as a numeric array.

    Example: `0, 1, 2, 3, 255` will be encoded as: `[0, 1, 2, 3, 255]`
    
Yes that is the default implementation. Only Apple knows why it is not [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) and [Base64](https://en.wikipedia.org/wiki/Base64). 🙃
Because I don't want to link against Foundation it is not possible to implement default encoding and decoding strategies for `Date` and `Data` as the Foundation implementation does. That's why, if you want to use another encoding/decoding strategy than the default you need to overwrite `encode(to: Encoder)` and `init(from: Decoder)`.

This could look like this:

```swift
struct MyEvent: Decodable {

  let eventTime: Date
  
  enum CodingKeys: String, CodingKey {
    case eventTime
  }

  init(from decoder: Decoder) {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let dateString = try container.decode(String.self, forKey: .eventTime)
    guard let timestamp = MyEvent.dateFormatter.date(from: dateString) else {
      let dateFormat = String(describing: MyEvent.dateFormatter.dateFormat)
      throw DecodingError.dataCorruptedError(forKey: .eventTime, in: container, debugDescription:
        "Expected date to be in format `\(dateFormat)`, but `\(dateFormat) does not forfill format`")
    }
    self.eventTime = timestamp
  }
  
  private static let dateFormatter: DateFormatter = MyEvent.createDateFormatter()
  private static func createDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    formatter.timeZone   = TimeZone(secondsFromGMT: 0)
    formatter.locale     = Locale(identifier: "en_US_POSIX")
    return formatter
  }
}
```

You can find more information about [encoding and decoding custom types in Apple's documentation](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types).

### UTF-16 and UTF-32

If your input is [UTF-16](https://en.wikipedia.org/wiki/UTF-16) or [UTF-32](https://en.wikipedia.org/wiki/UTF-32) encoded, you can easily convert it to UTF-8: 

```swift
let utf16 = UInt16[]() // your utf-16 encoded data
let utf8  = Array(String(decoding: utf16, as: Unicode.UTF16.self).utf8)
```

```swift
let utf32 = UInt32[]() // your utf-32 encoded data
let utf8  = Array(String(decoding: utf32, as: Unicode.UTF32.self).utf8)
```

## Contributing

Please feel welcome and encouraged to contribute to `pure-swift-json`. This is a very young endeavour and help is always welcome.

If you've found a bug, have a suggestion or need help getting started, please open an Issue or a PR. If you use this package, I'd be grateful for sharing your experience.

Focus areas for the time being:

- ensuring safe use of nested containers while encoding and decoding
- supporting camelCase and snakeCase aka [`KeyEncodingStrategy`](https://developer.apple.com/documentation/foundation/jsonencoder/keyencodingstrategy)

## Credits

- [@weissi](https://github.com/weissi) thanks for answering all my questions and for opening tickets [SR-12125](https://bugs.swift.org/browse/SR-12125) and [SR-12126](https://bugs.swift.org/browse/SR-12126)
- [@dinhhungle](https://github.com/dinhhungle) thanks for your quality assurance. It helped a lot! 
- [@Ro-M](https://github.com/Ro-M) thanks for checking my README.md
