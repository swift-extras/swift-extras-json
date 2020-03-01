import XCTest
@testable import PureSwiftJSONParsing

class NumberParserTests: XCTestCase {
  
  func testNumberWithEverything() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("-12.12e+12".utf8))
    XCTAssertEqual(result, .number("-12.12e+12"))
  }
  
  func testTwelve() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("12".utf8))
    XCTAssertEqual(result, .number("12"))
  }
  
  func testMinusTwelve() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("-12".utf8))
    XCTAssertEqual(result, .number("-12"))
  }
  
  func testMinusTwelvePointOne() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("-12.1".utf8))
    XCTAssertEqual(result, .number("-12.1"))
  }
  
  func testMinusTwelvePoint() throws {
    do {
      let result = try JSONParser().parse(bytes: [UInt8]("-12.".utf8))
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch JSONError.unexpectedEndOfFile {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testMinusTwelveExp1() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("-12e1".utf8))
    XCTAssertEqual(result, .number("-12e1"))
  }
  
  func testMinusTwelveExpMinus1() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("-12e-1".utf8))
    XCTAssertEqual(result, .number("-12e-1"))
  }
  
  func testMinusTwelveExpMinus() throws {
    do {
      let result = try JSONParser().parse(bytes: [UInt8]("-12e-".utf8))
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch JSONError.unexpectedEndOfFile {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testTwelvePointOneWithExp() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("12.1e-1".utf8))
    XCTAssertEqual(result, .number("12.1e-1"))
  }
  
  func testHighExp() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("1000e1000".utf8))
    XCTAssertEqual(result, .number("1000e1000"))
  }
  
  func testLeadingZero() throws {
    do {
      let result = try JSONParser().parse(bytes: [UInt8]("01".utf8))
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch JSONError.numberWithLeadingZero(index: 1) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testLeadingZeroNegative() throws {
    do {
      let result = try JSONParser().parse(bytes: [UInt8]("-01".utf8))
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch JSONError.numberWithLeadingZero(index: 2) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testZeroPointOne() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("0.1".utf8))
    XCTAssertEqual(result, .number("0.1"))
  }
  
  func testZeroPointZeroOne() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("0.01".utf8))
    XCTAssertEqual(result, .number("0.01"))
  }
  
  func testZeroPointZeroZeroOne() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("0.001".utf8))
    XCTAssertEqual(result, .number("0.001"))
  }
  
  func testOnePointZeroZeroZeroAllowed() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("1.000".utf8))
    XCTAssertEqual(result, .number("1.000"))
  }
  
  func testZeroExpOne() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("0e1".utf8))
    XCTAssertEqual(result, .number("0e1"))
  }
  
  func testZeroExpZero() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("0e0".utf8))
    XCTAssertEqual(result, .number("0e0"))
  }
  
  func testZeroExpMinusZero() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("0e-0".utf8))
    XCTAssertEqual(result, .number("0e-0"))
  }
    
  func testMinusPoint() throws {
    do {
      let result = try JSONParser().parse(bytes: [UInt8]("-.".utf8))
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "."), characterIndex: 1) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testSpaceInBetween() throws {
    do {
      let result = try JSONParser().parse(bytes: [UInt8]("1 000".utf8))
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "0"), characterIndex: 2) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testExpWithCapitalLetter() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("5E7".utf8))
    XCTAssertEqual(result, .number("5E7"))
  }
}
