import Foundation

protocol GithubUserMapper {
    func mapPeople(from data: Data) -> [GithubUser]
}

final class GithubUserMapperImpl: GithubUserMapper {
    func mapPeople(from data: Data) -> [GithubUser] {
        do {
            return try JSONDecoder().decode([GithubUser].self, from: data)
        } catch {
            print("Couldn't parse list of GithubPeople because \(error.localizedDescription)")
            return []
        }
    }
}
