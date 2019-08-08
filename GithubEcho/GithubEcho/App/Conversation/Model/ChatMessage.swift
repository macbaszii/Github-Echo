import Foundation

enum MessageType {
    case userMessage
    case echoMessage
}

struct ChatMessage {
    let message: String
    let type: MessageType
}
