@testable import ExtrasJSON
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

            let result = try XJSONDecoder().decode(HelloWorld.self, from: [UInt8](string.utf8))

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

        let json = #"{"hello":"world"}"#
        XCTAssertThrowsError(_ = try XJSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)) {
            error in
            guard case Swift.DecodingError.typeMismatch(let type, let context) = error else {
                XCTFail("Unexpected error: \(error)"); return
            }

            XCTAssertTrue(type == [JSONValue].self)
            XCTAssertEqual(context.debugDescription, "Expected to decode Array<JSONValue> but found a dictionary instead.")
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

        let json = #"["haha", "hihi"]"#
        XCTAssertThrowsError(_ = try XJSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)) {
            error in
            guard case Swift.DecodingError.typeMismatch(let type, let context) = error else {
                XCTFail("Unexpected error: \(error)"); return
            }

            XCTAssertTrue(type == [String: JSONValue].self)
            XCTAssertEqual(context.debugDescription, "Expected to decode Dictionary<String, JSONValue> but found an array instead.")
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

        let json = #"{"hello👩‍👩‍👧‍👧" 123 }"#
        XCTAssertThrowsError(_ = try XJSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)) {
            error in
            guard case Swift.DecodingError.dataCorrupted(let context) = error else {
                XCTFail("Unexpected error: \(error)"); return
            }

            XCTAssertEqual(context.codingPath.count, 0)
            XCTAssertEqual(context.debugDescription, "Unexpected character `1` at character index: 34")
            XCTAssertNotNil(context.underlyingError)
        }
    }

    func testDecodeEmptyArray() {
        let json = """
        {
            "array": []
        }
        """
        struct Foo: Decodable {
            let array: [String]
        }
        let decoder = XJSONDecoder()

        var result: Foo?
        XCTAssertNoThrow(result = try decoder.decode(Foo.self, from: json.utf8))
        XCTAssertEqual(result?.array, [])
    }

    func testIfUserInfoIsHandedDown() {
        let json = "{}"
        struct Foo: Decodable {
            init(decoder: Decoder) {
                XCTAssertEqual(decoder.userInfo as? [CodingUserInfoKey: String], [CodingUserInfoKey(rawValue: "foo")!: "bar"])
            }
        }
        var decoder = XJSONDecoder()
        decoder.userInfo[CodingUserInfoKey(rawValue: "foo")!] = "bar"
        XCTAssertNoThrow(_ = try decoder.decode(Foo.self, from: json.utf8))
    }
}
