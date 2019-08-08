import UIKit

protocol ConversationViewModuleBuildable {
    func build(people: GithubUser) -> UIViewController
}

final class ConversationViewModuleBuilder: ConversationViewModuleBuildable {
    func build(people: GithubUser) -> UIViewController {
        guard let viewController = try? ConversationViewController.loadFromNib() else {
            fatalError("Couldn't load ConversationViewController from nib file")
        }

        let presenter = ConversationViewPresenter(people: people)

        viewController.output = presenter
        presenter.view = viewController

        return viewController
    }
}
