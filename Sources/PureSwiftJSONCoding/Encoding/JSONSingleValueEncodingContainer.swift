
struct JSONSingleValueEncodingContainer: SingleValueEncodingContainer {
  
  let impl      : JSONEncoderImpl
  let codingPath: [CodingKey]
  
  private var firstValueWritten: Bool = false
  
  init(impl: JSONEncoderImpl, codingPath: [CodingKey]) {
    self.impl       = impl
    self.codingPath = codingPath
  }

  mutating func encodeNil() throws {
    
  }

  mutating func encode(_ value: Bool) throws {
    preconditionCanEncodeNewValue()
    self.impl.singleValue = .bool(value)
  }

  mutating func encode(_ value: Int) throws {
    try encodeFixedWidthInteger(value)
  }

  mutating func encode(_ value: Int8) throws {
    try encodeFixedWidthInteger(value)
  }

  mutating func encode(_ value: Int16) throws {
    try encodeFixedWidthInteger(value)
  }

  mutating func encode(_ value: Int32) throws {
    try encodeFixedWidthInteger(value)
  }

  mutating func encode(_ value: Int64) throws {
    try encodeFixedWidthInteger(value)
  }

  mutating func encode(_ value: UInt) throws {
    try encodeFixedWidthInteger(value)
  }

  mutating func encode(_ value: UInt8) throws {
    try encodeFixedWidthInteger(value)
  }

  mutating func encode(_ value: UInt16) throws {
    try encodeFixedWidthInteger(value)
  }

  mutating func encode(_ value: UInt32) throws {
    try encodeFixedWidthInteger(value)
  }

  mutating func encode(_ value: UInt64) throws {
    try encodeFixedWidthInteger(value)
  }

  mutating func encode(_ value: Float) throws {
    try encodeFloatingPoint(value)
  }

  mutating func encode(_ value: Double) throws {
    try encodeFloatingPoint(value)
  }
  
  mutating func encode(_ value: String) throws {
    preconditionCanEncodeNewValue()
    self.impl.singleValue = .string(value)
  }

  mutating func encode<T: Encodable>(_ value: T) throws {
    preconditionCanEncodeNewValue()
    try value.encode(to: self.impl)
  }
  
  func preconditionCanEncodeNewValue() {
    precondition(self.impl.singleValue == nil, "Attempt to encode value through single value container when previously value already encoded.")
  }
}

extension JSONSingleValueEncodingContainer {
  
  @inline(__always) private mutating func encodeFixedWidthInteger<N: FixedWidthInteger>(_ value: N) throws {
    preconditionCanEncodeNewValue()
    self.impl.singleValue = .number(value.description)
  }
  
  @inline(__always) private mutating func encodeFloatingPoint<N: FloatingPoint>(_ value: N)
    throws where N: CustomStringConvertible
  {
    preconditionCanEncodeNewValue()
    self.impl.singleValue = .number(value.description)
  }

}
