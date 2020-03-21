import PureSwiftJSONParsing

func run(identifier: String) {
    let sampleString = SampleStructure.sampleJSON
    let sampleBytes  = [UInt8](sampleString.utf8)
    let sampleJSON   = try! JSONParser().parse(bytes: sampleBytes)
    
    measure(identifier: identifier) {
        for _ in 0..<1_000 {
          var bytes = [UInt8]()       // <-- this is the only real allocation
          bytes.reserveCapacity(6000) // <-- reserve capactity so high we don't need reallocs
          sampleJSON.appendBytes(to: &bytes)
        }
      
        return 1_000
    }
}
