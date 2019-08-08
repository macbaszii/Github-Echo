import Foundation

struct CellIdentifiers {
    struct PeopleViewModule {
        static let peopleCell = String(describing: PeopleCell.self)
    }

    struct ConversationViewModule {
        static let senderMessageCell = String(describing: SenderMessageCell.self)
        static let echoMessageCell = String(describing: EchoMessageCell.self)
    }
}
