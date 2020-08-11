import PureSwiftJSON
import XCTest

class FoundationJSONEncoderTests: XCTestCase {
    struct HelloWorld: Encodable {
        struct SubType {
            let value: UInt
        }

        let hello = "Hello \tWorld"
        let subs: [SubType] = [SubType(value: 1), SubType(value: 1), SubType(value: 1)]
    }

    func testEncodeHelloWorld() throws {
        let hello = HelloWorld()
        let result = try Foundation.JSONEncoder().encode(hello)

        let value = try JSONParser().parse(bytes: result)
        XCTAssertEqual(value, .object([
            "hello": .string("Hello \tWorld"),
            "subs": .array([.number("1"), .number("1"), .number("1")]),
        ]))
    }

    #if canImport(Darwin)
    // this works only on Darwin, on Linux an error is thrown.
    func testEncodeNull() throws {
        let result = try Foundation.JSONEncoder().encode(nil as String?)

        let json = String(data: result, encoding: .utf8)
        XCTAssertEqual(json, "null")
    }
    #endif

    #if canImport(Darwin)
    // this works only on Darwin, on Linux an error is thrown.
    func testEncodeTopLevelString() throws {
        let result = try Foundation.JSONEncoder().encode("Hello World")

        let json = String(data: result, encoding: .utf8)
        XCTAssertEqual(json, #""Hello World""#)
    }
    #endif

    func testEncodeTopLevelDoubleNaN() throws {
        do {
            _ = try Foundation.JSONEncoder().encode(Double.nan)
        } catch Swift.EncodingError.invalidValue(let value as Double, _) {
            XCTAssert(value.isNaN) // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testEncodeTopLevelDoubleInfinity() throws {
        do {
            _ = try Foundation.JSONEncoder().encode(Double.infinity)
        } catch Swift.EncodingError.invalidValue(let value as Double, let context) {
            print(context)
            XCTAssert(value.isInfinite) // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    struct DoubleBox: Encodable {
        let number: Double
    }

    func testEncodeKeyedContainterDoubleInfinity() throws {
        do {
            _ = try Foundation.JSONEncoder().encode(DoubleBox(number: Double.infinity))
        } catch Swift.EncodingError.invalidValue(let value as Double, let context) {
            print(context)
            XCTAssert(value.isInfinite) // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    struct DoubleInArrayBox: Encodable {
        let number: Double

        func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(self.number)
        }
    }

    func testEncodeDoubleInUnkeyedContainerNAN() {
        do {
            let result = try Foundation.JSONEncoder().encode(DoubleInArrayBox(number: .nan))
            XCTFail("Did not expect to have a result: \(result)")
        } catch Swift.EncodingError.invalidValue(let value as Double, let context) {
            XCTAssert(value.isNaN) // expected
            XCTAssertEqual(context.codingPath.count, 1)
            XCTAssertEqual(context.codingPath.first?.stringValue, "Index 0")
            print(context)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

extension FoundationJSONEncoderTests.HelloWorld.SubType: Encodable {
    enum CodingKeys: String, CodingKey {
        case value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
