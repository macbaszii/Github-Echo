import Foundation

@testable import GithubEcho

final class MockConversationViewOutput: ConversationViewOutput, MockInvocable {
    var invocations: [Invocation] = []

    enum Invocation: MockInvocationEnum {
        case viewIsReady
        case sendMessage(message: String)
        case numberOfMessages
        case chatMessage(indexPath: IndexPath)
    }

    func viewIsReady() {
        invocations.append(.viewIsReady)
    }

    func sendMessage(_ message: String) {
        invocations.append(.sendMessage(message: message))
    }

    var mockNumberOfMessages = 10
    func numberOfMessages() -> Int {
        invocations.append(.numberOfMessages)
        return mockNumberOfMessages
    }

    private let mockUserMessage = ChatMessage(message: "Hello", type: .userMessage)
    private let mockEchoMessage = ChatMessage(message: "Hello Hello", type: .echoMessage)

    var shouldReturnUserMessage = true
    func chatMessage(at indexPath: IndexPath) -> ChatMessage {
        invocations.append(.chatMessage(indexPath: indexPath))

        if shouldReturnUserMessage {
            return mockUserMessage
        } else {
            return mockEchoMessage
        }
    }
}

final class MockConversationViewInput: ConversationViewInput, MockInvocable {
    var invocations: [Invocation] = []

    enum Invocation: MockInvocationEnum {
        case updateTitle(title: String)
        case reloadDataSource
        case clearInputField
        case enableSendButton
        case disableSendButton
    }

    func updateTitle(_ title: String) {
        invocations.append(.updateTitle(title: title))
    }

    func reloadDataSource() {
        invocations.append(.reloadDataSource)
    }

    func clearInputField() {
        invocations.append(.clearInputField)
    }

    func enableSendButton() {
        invocations.append(.enableSendButton)
    }

    func disableSendButton() {
        invocations.append(.disableSendButton)
    }
}
