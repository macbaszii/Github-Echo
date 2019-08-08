import Foundation

protocol ConversationViewInput: class {
    func updateTitle(_ title: String)
    func reloadDataSource()
    func clearInputField()
    func enableSendButton()
    func disableSendButton()
}

protocol ConversationViewOutput {
    func viewIsReady()
    func sendMessage(_ message: String)
    func numberOfMessages() -> Int
    func chatMessage(at indexPath: IndexPath) -> ChatMessage
}
