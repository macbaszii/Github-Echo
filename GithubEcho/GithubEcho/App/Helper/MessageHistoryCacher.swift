import Foundation

typealias CacheKey = String

protocol MessageHistoryCacher {

    func messageHistory(forUserId userId: Int64) -> [ChatMessage]
    func cacheMessage(_ message: ChatMessage, forUserId userId: Int64)
}

final class MessageHistoryCacherImpl: MessageHistoryCacher {

    static let shared = MessageHistoryCacherImpl()

    private let cacher: Cacher<CacheKey, MessageHistory>

    init(cacher: Cacher<CacheKey, MessageHistory> = Cacher<CacheKey, MessageHistory>()) {
        self.cacher = cacher
    }

    func messageHistory(forUserId userId: Int64) -> [ChatMessage] {
        guard let cached = cacher.value(forKey: String(userId)) else { return [] }
        return cached.messages
    }

    func cacheMessage(_ message: ChatMessage, forUserId userId: Int64) {
        if let existingCached = cacher.value(forKey: String(userId)) {
            var existingMessages = existingCached.messages
            existingMessages.append(message)

            cacher.removeValue(forKey: String(userId))
            cacher.insert(MessageHistory(messages: existingMessages), forKey: String(userId))
        } else {
            cacher.insert(MessageHistory(messages: [message]), forKey: String(userId))
        }
    }
}
