import Foundation

final class PeopleViewInteractor: PeopleViewInteractorInput {
    let apiClient: GithubAPIClient

    weak var output: PeopleViewInteractorOutput?

    init(apiClient: GithubAPIClient) {
        self.apiClient = apiClient
    }

    func fetchPeople() {
        apiClient.getUsers { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let people):
                strongSelf.output?.didReceivePeople(people)
            case .failure(let error):
                if let error = error as? GithubAPIClientError {
                    switch error {
                    case .apiRateLimitExceed(let message):
                        strongSelf.output?.didReceiveError(message)
                    }
                } else {
                    strongSelf.output?.didReceiveError(error.localizedDescription)
                }
            }
        }
    }
}
