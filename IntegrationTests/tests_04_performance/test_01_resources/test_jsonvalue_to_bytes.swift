import PureSwiftJSONParsing

func run(identifier: String) {
  let sampleString = SampleStructure.sampleJSON
  let sampleBytes  = [UInt8](sampleString.utf8)
  let sampleJSON   = try! JSONParser().parse(bytes: sampleBytes)

  var bytes = [UInt8]()       // <-- this is the only real allocation
  bytes.reserveCapacity(6000) // <-- reserve capactity so high we don't need reallocs
  
  measure(identifier: identifier) {
    for _ in 0..<1_000 {
      bytes.removeAll(keepingCapacity: true)
      sampleJSON.appendBytes(to: &bytes)
    }
  
    return bytes.count
  }
}
