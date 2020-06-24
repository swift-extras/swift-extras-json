@testable import PureSwiftJSONCoding
@testable import PureSwiftJSONParsing
import XCTest

class JSONDecoderTests: XCTestCase {
    func testDecodeHelloWorld() throws {
        struct HelloWorld: Codable {
            let hello: String
            let subStruct: SubStruct
            let test: Bool
            let number: UInt
            let numbers: [UInt]

            struct SubStruct: Codable, Equatable {
                let name: String
            }
        }

        do {
            let string = """
            {
              "hello":"world",
              "subStruct":{
                "name":"hihi"
              },
              "test":true,
              "number":123,
              "numbers":[
                12,
                345,
                78
              ]
            }
            """

            let result = try JSONDecoder().decode(HelloWorld.self, from: [UInt8](string.utf8))

            XCTAssertEqual(result.hello, "world")
            XCTAssertEqual(result.subStruct, HelloWorld.SubStruct(name: "hihi"))
            XCTAssertEqual(result.test, true)
            XCTAssertEqual(result.number, 123)
            XCTAssertEqual(result.numbers, [12, 345, 78])
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testGetUnkeyedContainerFromKeyedPayload() {
        struct HelloWorld: Decodable {
            init(from decoder: Decoder) throws {
                _ = try decoder.unkeyedContainer()
                XCTFail("Did not expect to reach this point")
            }
        }

        do {
            let json = #"{"hello":"world"}"#
            let result = try PureSwiftJSONCoding.JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch let Swift.DecodingError.typeMismatch(type, context) {
            // expected
            XCTAssertTrue(type == [JSONValue].self)
            XCTAssertEqual(context.debugDescription, "Expected to decode Array<JSONValue> but found a dictionary instead.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testGetKeyedContainerFromUnkeyedPayload() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey {
                case hello
            }

            init(from decoder: Decoder) throws {
                _ = try decoder.container(keyedBy: CodingKeys.self)
                XCTFail("Did not expect to reach this point")
            }
        }

        do {
            let json = #"["haha", "hihi"]"#
            let result = try PureSwiftJSONCoding.JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch let Swift.DecodingError.typeMismatch(type, context) {
            // expected
            XCTAssertTrue(type == [String: JSONValue].self)
            XCTAssertEqual(context.debugDescription, "Expected to decode Dictionary<String, JSONValue> but found an array instead.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testDecodeInvalidJSON() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey {
                case hello
            }

            init(from _: Decoder) throws {
                XCTFail("Did not expect to be called")
            }
        }

        do {
            let json = #"{"hello👩‍👩‍👧‍👧" 123 }"#
            let result = try PureSwiftJSONCoding.JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch let Swift.DecodingError.dataCorrupted(context) {
            // expected
            XCTAssertEqual(context.codingPath.count, 0)
            XCTAssertEqual(context.debugDescription, "Unexpected character `1` at character index: 34")
            XCTAssertNotNil(context.underlyingError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
