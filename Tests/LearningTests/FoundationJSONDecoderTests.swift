import PureSwiftJSON
import XCTest

class FoundationJSONDecoderTests: XCTestCase {
    func testGetUnkeyedContainerFromKeyedPayload() {
        struct HelloWorld: Decodable {
            init(from decoder: Decoder) throws {
                _ = try decoder.unkeyedContainer()
                XCTFail("Did not expect to reach this point")
            }
        }

        do {
            let json = #"{"hello":"world"}"#
            let result = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch Swift.DecodingError.typeMismatch(let type, let context) {
            // expected
            XCTAssertTrue(type == [Any].self)
            print(context)
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
            let result = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch Swift.DecodingError.typeMismatch(let type, let context) {
            // expected
            XCTAssertTrue(type == [String: Any].self)
            print(context)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    #if canImport(Darwin)
    // this works only on Darwin, on Linux an error is thrown.
    func testGetKeyedContainerFromSingleValuePayload() {
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
            let json = #""haha""#
            let result = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch Swift.DecodingError.typeMismatch(let type, let context) {
            // expected
            XCTAssertTrue(type == [String: Any].self)
            print(context)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    #endif

    func testDecodeStringFromNumberInKeyedContainer() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey {
                case hello
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                _ = try container.decode(String.self, forKey: .hello)
                XCTFail("Did not expect to reach this point")
            }
        }

        do {
            let json = #"{"hello": 12}"#
            let result = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch Swift.DecodingError.typeMismatch(let type, let context) {
            // expected
            XCTAssertTrue(type == String.self)
            print(context)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testDecodeStringFromNothingInKeyedContainer() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey {
                case hello
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                _ = try container.decode(String.self, forKey: .hello)
                XCTFail("Did not expect to reach this point")
            }
        }

        do {
            let json = "{}"
            let result = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch Swift.DecodingError.keyNotFound(let codingKey, let context) {
            // expected
            XCTAssertEqual(codingKey as? HelloWorld.CodingKeys, .hello)
            XCTAssertEqual(context.debugDescription, "No value associated with key CodingKeys(stringValue: \"hello\", intValue: nil) (\"hello\").")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testDecodeStringFromEmptySubContainer() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey {
                case hello
            }

            enum SubCodingKeys: String, CodingKey {
                case world
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                print(container.codingPath)
                let subContainer = try container.nestedContainer(keyedBy: SubCodingKeys.self, forKey: .hello)
                print(subContainer.codingPath)
                _ = try subContainer.decode(String.self, forKey: .world)

                XCTFail("Did not expect to reach this point")
            }
        }

        do {
            let json = #"{"hello": {}}"#
            let result = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch Swift.DecodingError.keyNotFound(let codingKey, let context) {
            // expected
            XCTAssertEqual(codingKey as? HelloWorld.SubCodingKeys, .world)
            XCTAssertEqual(context.debugDescription, "No value associated with key SubCodingKeys(stringValue: \"world\", intValue: nil) (\"world\").")
            print(context)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testGetUInt8FromTooLargeNumber() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey {
                case hello
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let number = try container.decode(UInt8.self, forKey: .hello)
                XCTFail("Did not expect to get a result: \(number)")
            }
        }

        let number = 312

        do {
            let json = #"{"hello": \#(number)}"#
            let result = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch Swift.DecodingError.dataCorrupted(let context) {
            // expected
            XCTAssertEqual(context.codingPath.count, 1)
            XCTAssertEqual(context.codingPath.first as? HelloWorld.CodingKeys, .hello)
            XCTAssertEqual(context.debugDescription, "Parsed JSON number <\(number)> does not fit in UInt8.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testGetUInt8FromFloat() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey {
                case hello
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let number = try container.decode(UInt8.self, forKey: .hello)
                XCTFail("Did not expect to get a result: \(number)")
            }
        }

        let number = 3.14

        do {
            let json = #"{"hello": \#(number)}"#
            let result = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch Swift.DecodingError.dataCorrupted(let context) {
            // expected
            XCTAssertEqual(context.codingPath.count, 1)
            XCTAssertEqual(context.codingPath.first as? HelloWorld.CodingKeys, .hello)
            XCTAssertEqual(context.debugDescription, "Parsed JSON number <\(number)> does not fit in UInt8.")
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
            let result = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch Swift.DecodingError.dataCorrupted(let context) {
            // expected
            XCTAssertEqual(context.codingPath.count, 0)
            print(context)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testDecodeUnexpectedEndJSON() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey {
                case hello
            }

            init(from _: Decoder) throws {
                XCTFail("Did not expect to be called")
            }
        }

        do {
            let json = #"{"hello👩‍👩‍👧‍👧" "#
            let result = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)
            XCTFail("Did not expect to get a result: \(result)")
        } catch Swift.DecodingError.dataCorrupted(let context) {
            // expected
            XCTAssertEqual(context.codingPath.count, 0)
            print(context)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testDecodePastEndOfUnkeyedContainer() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey { case list }

            init(from decoder: Decoder) throws {
                var container = try decoder.container(keyedBy: CodingKeys.self).nestedUnkeyedContainer(forKey: .list)
                _ = try container.decode(String.self)
            }
        }

        let json = #"{"list":[]}"#

        XCTAssertThrowsError(_ = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)) { error in
            guard case .valueNotFound(let type, let context) = (error as? DecodingError) else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertTrue(type is String.Type)
            XCTAssertEqual(context.codingPath.count, 1)
            XCTAssertEqual(context.codingPath.first?.intValue, 0)
            XCTAssertEqual(context.debugDescription, "Unkeyed container is at end.")
        }
    }

    func testDecodeNestedKeyedContainerPastEndOfUnkeyedContainer() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey { case list }

            init(from decoder: Decoder) throws {
                var container = try decoder.container(keyedBy: CodingKeys.self).nestedUnkeyedContainer(forKey: .list)
                _ = try container.nestedContainer(keyedBy: CodingKeys.self)
            }
        }

        let json = #"{"list":[]}"#

        XCTAssertThrowsError(_ = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)) { error in
            guard case .some(.valueNotFound(let type, let context)) = (error as? DecodingError) else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertTrue(type is KeyedDecodingContainer<HelloWorld.CodingKeys>.Type)
            XCTAssertEqual(context.codingPath.count, 1)
            XCTAssertEqual(context.codingPath.first?.stringValue, HelloWorld.CodingKeys.list.rawValue)
            XCTAssertEqual(context.debugDescription, "Cannot get nested keyed container -- unkeyed container is at end.")
        }
    }

    func testDecodeNestedUnkeyedContainerPastEndOfUnkeyedContainer() {
        struct HelloWorld: Decodable {
            enum CodingKeys: String, CodingKey { case list }

            init(from decoder: Decoder) throws {
                var container = try decoder.container(keyedBy: CodingKeys.self).nestedUnkeyedContainer(forKey: .list)
                _ = try container.nestedUnkeyedContainer()
            }
        }

        let json = #"{"list":[]}"#

        XCTAssertThrowsError(_ = try JSONDecoder().decode(HelloWorld.self, from: json.data(using: .utf8)!)) { error in
            guard case .some(.valueNotFound(let type, let context)) = (error as? DecodingError) else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertTrue(type is UnkeyedDecodingContainer.Protocol)
            XCTAssertEqual(context.codingPath.count, 1)
            XCTAssertEqual(context.codingPath.first?.stringValue, HelloWorld.CodingKeys.list.rawValue)
            XCTAssertEqual(context.debugDescription, "Cannot get nested keyed container -- unkeyed container is at end.")
        }
    }
}
