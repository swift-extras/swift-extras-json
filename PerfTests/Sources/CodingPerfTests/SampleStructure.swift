
struct SampleStructure: Codable {
  
  struct Friend: Codable {
    let id: Int
    let name: String
  }
  
  let id: String
  let index: Int
  let guid: String
  let isActive: Bool
  let balance: String
  let picture: String
  let age: Int
  let eyeColor: String
  let name: String
  let gender: String
  let company: String
  let email: String
  let phone: String
  let address: String
  let about: String
  let registered: String
  let latitude: Double
  let longitude: Double
  let tags: [String]
  let friends: [Friend]
  let greeting: String
  let favoriteFruit: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case index
    case guid
    case isActive
    case balance
    case picture
    case age
    case eyeColor
    case name
    case gender
    case company
    case email
    case phone
    case address
    case about
    case registered
    case latitude
    case longitude
    case tags
    case friends
    case greeting
    case favoriteFruit
  }
}

extension SampleStructure {
  
  static let sampleJSON = """
    [
      {
        "_id": "5e24ed2749789afeebcaa1ca",
        "index": 0,
        "guid": "d71ca8d9-974b-4e37-9660-660e39d139f2",
        "isActive": false,
        "balance": "$1,517.96",
        "picture": "http://placehold.it/32x32",
        "age": 30,
        "eyeColor": "brown",
        "name": "Spence Maynard",
        "gender": "male",
        "company": "SLAX",
        "email": "spencemaynard@slax.com",
        "phone": "+1 (954) 579-3152",
        "address": "506 Jefferson Avenue, Richford, Maine, 8603",
        "about": "Velit ipsum anim commodo sunt et laboris pariatur esse labore. Elit sunt velit enim mollit laboris minim incididunt consequat adipisicing fugiat proident incididunt. Consectetur voluptate nisi minim et commodo incididunt laborum labore. Adipisicing ullamco pariatur duis velit occaecat anim anim ea pariatur reprehenderit reprehenderit aliquip aliqua.\\r\\n",
        "registered": "2019-05-18T11:16:46 -02:00",
        "latitude": 73.687756,
        "longitude": 40.200524,
        "tags": [
          "ad",
          "dolor",
          "pariatur",
          "irure",
          "sit",
          "dolore",
          "voluptate"
        ],
        "friends": [
          {
            "id": 0,
            "name": "Ava Mcfarland"
          },
          {
            "id": 1,
            "name": "Bolton Nunez"
          },
          {
            "id": 2,
            "name": "Jan Myers"
          }
        ],
        "greeting": "Hello, Spence Maynard! You have 2 unread messages.",
        "favoriteFruit": "apple"
      },
      {
        "_id": "5e24ed27525a50f7493e601e",
        "index": 1,
        "guid": "885c02a4-7443-4b66-bdd5-ef87703b9e05",
        "isActive": false,
        "balance": "$2,637.14",
        "picture": "http://placehold.it/32x32",
        "age": 24,
        "eyeColor": "green",
        "name": "Willie Duncan",
        "gender": "female",
        "company": "FLUMBO",
        "email": "willieduncan@flumbo.com",
        "phone": "+1 (844) 532-2869",
        "address": "892 Emerald Street, Jacksonwald, American Samoa, 536",
        "about": "Irure anim duis ea voluptate aute aute dolor. Do eu anim aliqua qui aliquip. Id excepteur duis adipisicing sit nostrud do fugiat magna nulla consequat labore. Amet anim ut occaecat mollit. Occaecat laboris amet culpa ipsum sit nostrud ipsum sit ullamco mollit voluptate cupidatat.\\r\\n",
        "registered": "2017-08-05T01:30:38 -02:00",
        "latitude": 62.339371,
        "longitude": -71.180251,
        "tags": [
          "magna",
          "et",
          "sunt",
          "aute",
          "officia",
          "commodo",
          "excepteur"
        ],
        "friends": [
          {
            "id": 0,
            "name": "Kari Nielsen"
          },
          {
            "id": 1,
            "name": "Charity Joyce"
          },
          {
            "id": 2,
            "name": "Jane Hardy"
          }
        ],
        "greeting": "Hello, Willie Duncan! You have 3 unread messages.",
        "favoriteFruit": "strawberry"
      },
      {
        "_id": "5e24ed2733f6f6af0c36c1f6",
        "index": 2,
        "guid": "c6d704bd-b048-4ec9-b73a-ab5f43a3379f",
        "isActive": true,
        "balance": "$3,937.51",
        "picture": "http://placehold.it/32x32",
        "age": 36,
        "eyeColor": "brown",
        "name": "Lynn Cooke",
        "gender": "male",
        "company": "QUONATA",
        "email": "lynncooke@quonata.com",
        "phone": "+1 (999) 546-2919",
        "address": "134 Nassau Avenue, Springville, Alabama, 5401",
        "about": "Exercitation mollit ex duis id reprehenderit cupidatat cupidatat voluptate exercitation ea nulla commodo ea. Minim do anim magna proident irure voluptate aliquip labore sint velit exercitation non. Laborum ex deserunt est do fugiat cillum reprehenderit mollit enim sit excepteur esse aliqua. Pariatur mollit qui culpa est esse laboris laboris. Eu commodo labore duis qui nulla amet excepteur tempor laboris.\\r\\n",
        "registered": "2015-07-31T10:03:05 -02:00",
        "latitude": 73.37703,
        "longitude": -133.673108,
        "tags": [
          "sit",
          "occaecat",
          "dolor",
          "et",
          "minim",
          "esse",
          "Lorem"
        ],
        "friends": [
          {
            "id": 0,
            "name": "Trujillo Crawford"
          },
          {
            "id": 1,
            "name": "Kasey Cox"
          },
          {
            "id": 2,
            "name": "Janna Mckenzie"
          }
        ],
        "greeting": "Hello, Lynn Cooke! You have 10 unread messages.",
        "favoriteFruit": "banana"
      },
      {
        "_id": "5e24ed2706c97b2346814eb7",
        "index": 3,
        "guid": "5d2e248d-58a3-41c4-a489-a5a594c2b095",
        "isActive": true,
        "balance": "$3,239.24",
        "picture": "http://placehold.it/32x32",
        "age": 22,
        "eyeColor": "brown",
        "name": "Karyn Lyons",
        "gender": "female",
        "company": "ISOPOP",
        "email": "karynlyons@isopop.com",
        "phone": "+1 (827) 530-2404",
        "address": "701 Middleton Street, Spokane, Guam, 4740",
        "about": "Labore pariatur aute excepteur nisi. Do quis proident ex aute magna ad in mollit proident consequat. Cillum aliquip qui commodo consectetur mollit voluptate magna anim qui do veniam consequat cillum. Ex velit proident anim non dolore nulla consectetur deserunt tempor ullamco ullamco proident labore. Enim dolore adipisicing deserunt proident irure. In esse velit labore dolore pariatur in Lorem cillum nostrud commodo mollit ut duis cillum.\\r\\n",
        "registered": "2014-05-29T10:03:23 -02:00",
        "latitude": -49.181779,
        "longitude": 144.346629,
        "tags": [
          "non",
          "occaecat",
          "sit",
          "sit",
          "laborum",
          "deserunt",
          "deserunt"
        ],
        "friends": [
          {
            "id": 0,
            "name": "Suzanne Glover"
          },
          {
            "id": 1,
            "name": "Naomi Ramsey"
          },
          {
            "id": 2,
            "name": "Ilene Delacruz"
          }
        ],
        "greeting": "Hello, Karyn Lyons! You have 5 unread messages.",
        "favoriteFruit": "apple"
      },
      {
        "_id": "5e24ed27d3b2fd7c193400d1",
        "index": 4,
        "guid": "abcdf903-4ace-4b90-bb87-177b44a59bcc",
        "isActive": false,
        "balance": "$3,549.22",
        "picture": "http://placehold.it/32x32",
        "age": 32,
        "eyeColor": "green",
        "name": "Vargas Todd",
        "gender": "male",
        "company": "ULTRIMAX",
        "email": "vargastodd@ultrimax.com",
        "phone": "+1 (923) 517-2286",
        "address": "491 Commerce Street, Sidman, Nebraska, 8559",
        "about": "Dolor in laborum nulla aliquip reprehenderit mollit officia veniam ipsum cupidatat adipisicing non proident anim. Laborum excepteur nulla ex ex pariatur sint velit. Fugiat do ea velit laborum elit nostrud officia Lorem duis. Aliquip cillum cupidatat aliquip veniam. Adipisicing labore ea duis cupidatat magna sunt mollit qui nulla commodo. Duis minim eu nostrud elit cupidatat voluptate nisi laborum incididunt exercitation officia. Magna nisi cillum cupidatat officia aute.\\r\\n",
        "registered": "2014-03-28T07:06:26 -01:00",
        "latitude": 55.276691,
        "longitude": -57.627938,
        "tags": [
          "anim",
          "adipisicing",
          "nisi",
          "ad",
          "quis",
          "dolor",
          "ut"
        ],
        "friends": [
          {
            "id": 0,
            "name": "Lilly Bennett"
          },
          {
            "id": 1,
            "name": "Adkins Harris"
          },
          {
            "id": 2,
            "name": "Stacy Sanders"
          }
        ],
        "greeting": "Hello, Vargas Todd! You have 5 unread messages.",
        "favoriteFruit": "apple"
      }
    ]
    """
}
