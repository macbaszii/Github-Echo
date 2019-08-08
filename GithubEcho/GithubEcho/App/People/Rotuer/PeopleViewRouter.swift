import UIKit

final class PeopleViewRouter: PeopleViewRouterInput {
    weak var parentViewController: UIViewController?
    let conversationBuilder: ConversationViewModuleBuildable

    init(conversationBuilder: ConversationViewModuleBuildable) {
        self.conversationBuilder = conversationBuilder
    }

    func navigateToConversation(for people: GithubUser) {
        let conversationVC = conversationBuilder.build(people: people)
        parentViewController?.navigationController?.pushViewController(conversationVC, animated: true)
    }

    func showAlert(_ alert: UIAlertController) {
        parentViewController?.present(alert, animated: true, completion: nil)
    }
}
