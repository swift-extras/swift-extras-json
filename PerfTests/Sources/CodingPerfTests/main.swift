import Foundation
import PureSwiftJSON
#if os(macOS)
import SwiftyJSON
#endif
import IkigaJSON
import NIO
import NIOFoundationCompat

let runs = 10000

@discardableResult
func timing(name: String, execute: () throws -> Void) rethrows -> TimeInterval {
    let start = Date()
    try execute()
    let time = -start.timeIntervalSinceNow
    print("\(name) | took: \(String(format: "%.5f", time))s")
    return time
}

let sampleString = SampleStructure.sampleJSON
let sampleBytes = [UInt8](sampleString.utf8)
let sampleStruct = try PSJSONDecoder().decode([SampleStructure].self, from: sampleBytes)
let sampleJSON = try JSONParser().parse(bytes: sampleBytes)

print("Number of invocations: \(runs)")

print("------------------------------------------")
print("JSONValue to bytes")

let toBytes = timing(name: "PureSwift                    ") {
    for _ in 1 ... runs {
        var bytes = [UInt8]()
        bytes.reserveCapacity(2000)
        sampleJSON.appendBytes(to: &bytes)
    }
}

print("------------------------------------------")
print("Encoding")

let foundationEncoder = JSONEncoder()
let foundationEncoding = try timing(name: "Foundation                   ") {
    for _ in 1 ... runs {
        _ = try foundationEncoder.encode(sampleStruct)
    }
}

let ikigaDBEncoder = IkigaJSONEncoder()
let ikigaEncoding = try timing(name: "Ikiga                        ") {
    for _ in 1 ... runs {
        _ = try ikigaDBEncoder.encode(sampleStruct)
    }
}

let pureEncoder = PSJSONEncoder()
let pureEncoding = try timing(name: "PureSwift                    ") {
    for _ in 1 ... runs {
        _ = try pureEncoder.encode(sampleStruct)
    }
}

print("------------------------------------------")
print("Reading")

let sampleData = sampleString.data(using: .utf8)!

let reading = timing(name: "PureSwift on [UInt8]         ") {
    for _ in 1 ... runs {
        var iterator = sampleBytes.makeIterator()
        while let _ = iterator.next() {}
    }
}

let readingFoundationData = timing(name: "PureSwift on Foundation.Data ") {
    for _ in 1 ... runs {
        var iterator = sampleData.makeIterator()
        while let _ = iterator.next() {}
    }
}

let readingNIOByteBuffer = timing(name: "PureSwift on NIO.ByteBuffer  ") {
    for _ in 1 ... runs {
        var buffer = ByteBufferAllocator().buffer(capacity: sampleBytes.count)
        buffer.writeBytes(sampleBytes)

        var iterator = buffer.readableBytesView.makeIterator()
        while let _ = iterator.next() {}
    }
}

print("------------------------------------------")
print("Parsing")

let foundationParsing = try timing(name: "Foundation on Foundation.Data") {
    for _ in 1 ... runs {
        _ = try JSONSerialization.jsonObject(with: sampleData, options: [])
    }
}

let pureParsing = try timing(name: "PureSwift on [UInt8]         ") {
    for _ in 1 ... runs {
        _ = try JSONParser().parse(bytes: sampleBytes)
    }
}

let pureParsingData = try timing(name: "PureSwift on Foundation.Data ") {
    for _ in 1 ... runs {
        _ = try JSONParser().parse(bytes: sampleData)
    }
}

let pureParsingBuffer = try timing(name: "PureSwift on NIO.ByteBuffer  ") {
    for _ in 1 ... runs {
        var buffer = ByteBufferAllocator().buffer(capacity: sampleBytes.count)
        buffer.writeBytes(sampleBytes)
        _ = try JSONParser().parse(bytes: buffer.readBytes(length: buffer.readableBytes)!)
    }
}

#if os(macOS)
let swiftyJSONParsing = try timing(name: "SwiftyJSON                   ") {
    for _ in 1 ... runs {
        _ = try JSON(data: sampleData)
    }
}
#endif

print("------------------------------------------")
print("Decoding")

let foundationDecoder = JSONDecoder()
let foundationDecoding = try timing(name: "Foundation on Foundation.Data") {
    for _ in 1 ... runs {
        _ = try foundationDecoder.decode([SampleStructure].self, from: sampleData)
    }
}

let foundationDecodingBuffer = try timing(name: "Foundation on NIO.ByteBuffer ") {
    for _ in 1 ... runs {
        var buffer = ByteBufferAllocator().buffer(capacity: sampleBytes.count)
        buffer.writeBytes(sampleBytes)
        _ = try foundationDecoder.decode([SampleStructure].self, from: buffer)
    }
}

let ikigaDecoder = IkigaJSONDecoder()

let ikigaDecoding = try timing(name: "IkigaJSON on [UInt8]         ") {
    for _ in 1 ... runs {
        _ = try ikigaDecoder.decode([SampleStructure].self, from: sampleBytes)
    }
}

let ikigaDecodingData = try timing(name: "IkigaJSON on Foundation.Data ") {
    for _ in 1 ... runs {
        _ = try ikigaDecoder.decode([SampleStructure].self, from: sampleData)
    }
}

let ikigaDecodingBuffer = try timing(name: "IkigaJSON on NIO.ByteBuffer  ") {
    for _ in 1 ... runs {
        var buffer = ByteBufferAllocator().buffer(capacity: sampleBytes.count)
        buffer.writeBytes(sampleBytes)
        _ = try ikigaDecoder.decode([SampleStructure].self, from: buffer)
    }
}

let pureDecoder = PSJSONDecoder()
let pureDecoding = try timing(name: "PureSwift on [UInt8]         ") {
    for _ in 1 ... runs {
        _ = try pureDecoder.decode([SampleStructure].self, from: sampleBytes)
    }
}

let pureDecodingOnData = try timing(name: "PureSwift on Foundation.Data ") {
    for _ in 1 ... runs {
        _ = try pureDecoder.decode([SampleStructure].self, from: sampleData)
    }
}

let pureDecodingOnByteBuffer = try timing(name: "PureSwift on NIO.ByteBuffer  ") {
    for _ in 1 ... runs {
        var buffer = ByteBufferAllocator().buffer(capacity: sampleBytes.count)
        buffer.writeBytes(sampleBytes)
        _ = try pureDecoder.decode(
            [SampleStructure].self,
            from: buffer.readBytes(length: buffer.readableBytes)!
        )
    }
}
