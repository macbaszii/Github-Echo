import Foundation

final class PeopleViewPresenter: PeopleViewOutput, PeopleViewInteractorOutput {
    weak var view: PeopleViewInput?
    var interactor: PeopleViewInteractorInput?
    var router: PeopleViewRouterInput?

    private var people: [GithubUser] = []

    let alertBuilder: AlertBuildable

    init(alertBuilder: AlertBuildable = AlertBuilder()) {
        self.alertBuilder = alertBuilder
    }

    // MAKR: - PeopleViewOutput

    func viewIsReady() {
        view?.showLoadingView()
        interactor?.fetchPeople()
    }

    func numberOfPeople() -> Int {
        return people.count
    }

    func people(at indexPath: IndexPath) -> GithubUser {
        return people[indexPath.row]
    }

    func didSelectPeople(at indexPath: IndexPath) {
        let currentPeople = people(at: indexPath)
        router?.navigateToConversation(for: currentPeople)
    }

    // MARK: - PeopleViewInteractorOutput

    func didReceivePeople(_ people: [GithubUser]) {
        view?.hideLoadingView()
        self.people = people
        view?.updateDataSource()
    }

    func didReceiveError(_ message: String) {
        view?.hideLoadingView()
        let alert = alertBuilder.buildAlertView(
            title: nil,
            message: message,
            proceedButtonTitle: "Ok",
            cancelButtonTitle: nil,
            proceedCompletion: nil,
            cancelCompletion: nil)
        router?.showAlert(alert)
    }
}
