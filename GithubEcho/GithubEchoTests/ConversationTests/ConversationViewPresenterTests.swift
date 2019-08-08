import XCTest

@testable import GithubEcho

final class ConversationViewPresenterTests: XCTestCase {

    var presenter: ConversationViewPresenter!
    var mockView: MockConversationViewInput!

    override func setUp() {
        super.setUp()
        presenter = ConversationViewPresenter(
            people: GithubUser(username: "macbaszii", imageURL: "macbaszii.png")
        )
        mockView = MockConversationViewInput()

        presenter.view = mockView
    }

    override func tearDown() {
        presenter = nil
        mockView = nil

        super.tearDown()
    }

    func testViewIsReady() {
        let expectedTitle = "@macbaszii"
        presenter.viewIsReady()

        XCTAssertTrue(mockView.isCalledWithParameter(.updateTitle(title: expectedTitle)))
    }

    func testSendMessage() {
        presenter.sendMessage("Hello")

        XCTAssertTrue(mockView.isCalled(.disableSendButton))
        XCTAssertTrue(mockView.isCalled(.clearInputField))
        XCTAssertEqual(presenter.numberOfMessages(), 1)
        XCTAssertTrue(mockView.isCalled(.reloadDataSource))
    }

    func testSendEmptyMessage() {
        presenter.sendMessage("")

        XCTAssertFalse(mockView.isCalled(.disableSendButton))
        XCTAssertFalse(mockView.isCalled(.clearInputField))
        XCTAssertFalse(mockView.isCalled(.reloadDataSource))
    }

    func testGetNumberOfMessage() {
        presenter.sendMessage("Hello")
        presenter.sendMessage("Hi")

        let result = presenter.numberOfMessages()

        XCTAssertEqual(result, 2)
    }

    func testGetMessageAtIndexPath() {
        let expectedFirstMessage = "Hello"
        let expectedSecondMessage = "I'm Your father"

        presenter.sendMessage(expectedFirstMessage)
        presenter.sendMessage(expectedSecondMessage)

        let firstMessage = presenter.chatMessage(at: IndexPath(row: 0, section: 0))
        let secondMessage = presenter.chatMessage(at: IndexPath(row: 1, section: 0))

        XCTAssertEqual(firstMessage.message, expectedFirstMessage)
        XCTAssertEqual(secondMessage.message, expectedSecondMessage)
    }
}
