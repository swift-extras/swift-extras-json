
struct ArrayKey: CodingKey, Equatable {
    init(index: Int) {
        self.intValue = index
    }

    init?(stringValue _: String) {
        preconditionFailure("Did not expect to be initialized with a string")
    }

    init?(intValue: Int) {
        self.intValue = intValue
    }

    var intValue: Int?

    var stringValue: String {
        "Index \(self.intValue!)"
    }
}

func == (lhs: ArrayKey, rhs: ArrayKey) -> Bool {
    precondition(lhs.intValue != nil)
    precondition(rhs.intValue != nil)
    return lhs.intValue == rhs.intValue
}
