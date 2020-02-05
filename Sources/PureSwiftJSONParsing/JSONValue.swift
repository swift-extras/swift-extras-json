
public enum JSONError: Swift.Error {
  case unexpectedCharacter(ascii: UInt8)
  case unexpectedEndOfFile
}

public enum JSONValue {
  
  case string(String)
  case number(String)
  case bool(Bool)
  case null
  
  case array([JSONValue])
  case object([String: JSONValue])
  
}

extension JSONValue {
  
  public func appendBytes(to bytes: inout [UInt8]) {
    
    switch self {
    case .null:
      bytes.append(contentsOf: [
        UInt8(ascii: "n"), UInt8(ascii: "u"), UInt8(ascii: "l"), UInt8(ascii: "l")
      ])
    case .bool(true):
      bytes.append(contentsOf: [
        UInt8(ascii: "t"), UInt8(ascii: "r"), UInt8(ascii: "u"), UInt8(ascii: "e")
      ])
    case .bool(false):
      bytes.append(contentsOf: [
        UInt8(ascii: "f"), UInt8(ascii: "a"), UInt8(ascii: "l"), UInt8(ascii: "s"), UInt8(ascii: "e")
      ])
    case .string(let string):
      bytes.append(UInt8(ascii: "\""))
      bytes.append(contentsOf: string.utf8)
      bytes.append(UInt8(ascii: "\""))
    case .number(let string):
      bytes.append(contentsOf: string.utf8)
    case .array(let array):
      var iterator = array.makeIterator()
      bytes.append(UInt8(ascii: "["))
      // we don't kine branching, this is why we have this extra
      if let first = iterator.next() {
        first.appendBytes(to: &bytes)
      }
      while let item = iterator.next() {
        bytes.append(UInt8(ascii: ","))
        item.appendBytes(to: &bytes)
      }
      bytes.append(UInt8(ascii: "]"))
    case .object(let dict):
      var iterator = dict.makeIterator()
      bytes.append(UInt8(ascii: "{"))
      if let (key, value) = iterator.next() {
        bytes.append(UInt8(ascii: "\""))
        bytes.append(contentsOf: key.utf8)
        bytes.append(UInt8(ascii: "\""))
        bytes.append(UInt8(ascii: ":"))
        value.appendBytes(to: &bytes)
      }
      while let (key, value) = iterator.next() {
        bytes.append(UInt8(ascii: ","))
        bytes.append(UInt8(ascii: "\""))
        bytes.append(contentsOf: key.utf8)
        bytes.append(UInt8(ascii: "\""))
        bytes.append(UInt8(ascii: ":"))
        value.appendBytes(to: &bytes)
      }
      bytes.append(UInt8(ascii: "}"))
    }
  }
}

// MARK: - Protocol conformances -

// MARK: Equatable

extension JSONValue: Equatable { }

public func == (lhs: JSONValue, rhs: JSONValue) -> Bool {
  
  switch (lhs, rhs) {
  case (.null, .null):
    return true
  case (.bool(let lhs), .bool(let rhs)):
    return lhs == rhs
  case (.number(let lhs), .number(let rhs)):
    return lhs == rhs
  case (.string(let lhs), .string(let rhs)):
    return lhs == rhs
  case (.array(let lhs), .array(let rhs)):
    guard lhs.count == rhs.count else {
      return false
    }
    
    var lhsiterator = lhs.makeIterator()
    var rhsiterator = rhs.makeIterator()
    
    while let lhs = lhsiterator.next(), let rhs = rhsiterator.next() {
      if lhs == rhs {
        continue
      }
      return false
    }
    
    return true
  case (.object(let lhs), .object(let rhs)):
    guard lhs.count == rhs.count else {
      return false
    }
    
    var lhsiterator = lhs.makeIterator()
    
    while let (lhskey, lhsvalue) = lhsiterator.next() {
      guard let rhsvalue = rhs[lhskey] else {
        return false
      }
      
      if lhsvalue == rhsvalue {
        continue
      }
      return false
    }
    
    return true
  default:
    return false
  }
}
