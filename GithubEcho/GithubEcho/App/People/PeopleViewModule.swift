import UIKit

protocol PeopleViewInput: class {
    func updateDataSource()
    func showLoadingView()
    func hideLoadingView()
}

protocol PeopleViewOutput {
    func viewIsReady()
    func numberOfPeople() -> Int
    func people(at indexPath: IndexPath) -> GithubUser
    func didSelectPeople(at indexPath: IndexPath)
}

protocol PeopleViewInteractorInput {
    func fetchPeople()
}

protocol PeopleViewInteractorOutput: class {
    func didReceivePeople(_ people: [GithubUser])
    func didReceiveError(_ message: String)
}

protocol PeopleViewRouterInput {
    func navigateToConversation(for people: GithubUser)
    func showAlert(_ alert: UIAlertController)
}
