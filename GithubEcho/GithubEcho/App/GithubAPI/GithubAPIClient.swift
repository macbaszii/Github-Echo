import Foundation

enum GithubAPIClientError: Error {
    case apiRateLimitExceed(message: String)
}

protocol GithubAPIClient {
    func getUsers(completion: @escaping (Result<[GithubUser]>) -> Void)
}

final class GithubAPIClientImplementation: GithubAPIClient {
    struct Constants {
        static let getUsersURL = "https://api.github.com/users"
        static let rateLimitRemainingField = "X-RateLimit-Remaining"
        static let rateLimitErrorMessage = "API rate limit exceeded, Please try again after an hour"
    }

    let networkConnector: NetworkConnector
    let githubPeopleMapper: GithubPeopleMapper

    init(networkConnector: NetworkConnector,
         githubPeopleMapper: GithubPeopleMapper) {
        self.networkConnector = networkConnector
        self.githubPeopleMapper = githubPeopleMapper
    }

    func getUsers(completion: @escaping (Result<[GithubUser]>) -> Void) {
        guard let url = URL(string: Constants.getUsersURL) else { return }
        let task = networkConnector.request(url: url) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let result):
                if strongSelf.apiRateLimitExceeded(for: result.urlResponse) {
                    completion(.failure(GithubAPIClientError.apiRateLimitExceed(
                        message: Constants.rateLimitErrorMessage
                    )))
                } else {
                    let mappedPeople = strongSelf.githubPeopleMapper.mapPeople(from: result.data)
                    completion(.success(mappedPeople))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

        task.resume()
    }

    private func apiRateLimitExceeded(for response: HTTPURLResponse) -> Bool {
        if let limitRemainingString = response.allHeaderFields[Constants.rateLimitRemainingField] as? String,
            let limitRemaining = Int(limitRemainingString),
            limitRemaining == 0 {
            return true
        }

        return false
    }
}
