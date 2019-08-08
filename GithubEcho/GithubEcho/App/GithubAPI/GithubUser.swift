import Foundation

struct GithubUser: Codable {
    let username: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case username = "login"
        case imageURL = "avatar_url"
    }
}
