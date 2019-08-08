import Foundation

final class ConversationViewPresenter: ConversationViewOutput {
    weak var view: ConversationViewInput?
    private var chatMessages: [ChatMessage] = []

    let people: GithubUser
    
    init(people: GithubUser) {
        self.people = people
    }

    func viewIsReady() {
        view?.updateTitle("@\(people.username)")
    }

    func sendMessage(_ message: String) {
        guard !message.isEmpty else { return }
        let senderMessage = ChatMessage(
            message: message,
            type: .userMessage
        )

        view?.disableSendButton()
        view?.clearInputField()
        appendChatMessage(senderMessage)
        echoMessage(message)
    }

    func numberOfMessages() -> Int {
        return chatMessages.count
    }

    func chatMessage(at indexPath: IndexPath) -> ChatMessage {
        return chatMessages[indexPath.row]
    }

    // MARK: - Private
    private func appendChatMessage(_ chatMessage: ChatMessage) {
        chatMessages.append(chatMessage)
        view?.reloadDataSource()
    }

    private func echoMessage(_ message: String) {
        let echoMessage = ChatMessage(
            message: "\(message) \(message)",
            type: .echoMessage
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.appendChatMessage(echoMessage)
        }
    }
}
