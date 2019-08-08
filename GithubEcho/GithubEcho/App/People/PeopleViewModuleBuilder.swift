import UIKit

protocol PeopleViewModuleBuildable {
    func build() -> UIViewController
}

final class PeopleViewModuleBuilder: PeopleViewModuleBuildable {
    func build() -> UIViewController {
        guard let viewController = try? PeopleViewController.loadFromNib() else {
            fatalError("Couldn't initialzed PeopleViewController from nib file")
        }

        let presenter = PeopleViewPresenter()

        let networkConnector = NetworkConnectorImplementation()
        let githubPeopleMapper = GithubPeopleMapperImplementation()
        let apiClient = GithubAPIClientImplementation(
            networkConnector: networkConnector,
            githubPeopleMapper: githubPeopleMapper
        )
        let interactor = PeopleViewInteractor(
            apiClient: apiClient
        )

        let conversationModuleBuilder = ConversationViewModuleBuilder()
        let router = PeopleViewRouter(conversationBuilder: conversationModuleBuilder)

        viewController.output = presenter

        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter

        router.parentViewController = viewController

        return viewController
    }
}
