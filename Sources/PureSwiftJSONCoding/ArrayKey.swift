
struct ArrayKey: CodingKey {
  
  init(index: Int) {
    self.intValue = index
  }
  
  init?(stringValue: String) {
    preconditionFailure("Did not expect to be initialized with a string")
  }
  
  init?(intValue: Int) {
    self.intValue = intValue
  }
  
  var intValue: Int?
  
  var stringValue: String {
    return "Index \(intValue!)"
  }
}
