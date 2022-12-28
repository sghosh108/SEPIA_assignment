import Foundation

struct Pets: Decodable{
    var pets: [PetDetail]!
}

struct PetDetail: Decodable{
    var image_url: String!
    var title: String!
    var content_url: String!
    var date_added: String!
}

struct Settings: Decodable{
    var workHours: String!
}
