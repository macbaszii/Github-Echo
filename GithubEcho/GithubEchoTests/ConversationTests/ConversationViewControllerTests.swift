import XCTest

@testable import GithubEcho

final class ConversationViewControllerTests: XCTestCase {

    var viewController: ConversationViewController!
    var mockOutput: MockConversationViewOutput!


    override func setUp() {
        super.setUp()

        do {
            viewController = try ConversationViewController.loadFromNib()
        } catch {
            XCTFail("Couldn't load ConversationViewController from nib file")
        }

        mockOutput = MockConversationViewOutput()

        viewController.output = mockOutput
        XCTAssertNotNil(viewController.view) // -viewDidLoad will be triggered here
    }

    override func tearDown() {
        viewController = nil
        mockOutput = nil

        super.tearDown()
    }

    func testSendButtonTapped() {
        let expectedText = "Hello, World"
        viewController.messageTextField.text = expectedText
        viewController.sendButtonTapped(UIButton())

        XCTAssertTrue(mockOutput.isCalledWithParameter(.sendMessage(message: expectedText)))
    }

    func testViewDidLoad() {
        XCTAssertTrue(mockOutput.isCalled(.viewIsReady))
    }

    func testUpdateTitle() {
        let expectedTitle = "Mock Title"
        viewController.updateTitle(expectedTitle)

        XCTAssertEqual(viewController.title, expectedTitle)
    }

    func testClearInputField() {
        viewController.clearInputField()

        XCTAssertTrue((viewController.messageTextField.text ?? "" ).isEmpty)
    }

    func testEnableSendButton() {
        viewController.enableSendButton()

        XCTAssertTrue(viewController.sendButton.isEnabled)
    }

    func testDisableSendButton() {
        viewController.disableSendButton()

        XCTAssertFalse(viewController.sendButton.isEnabled)
    }

    func testTextDidChange() {
        viewController.messageTextField.text = "Hello"
        viewController.textDidChange(textField: viewController.messageTextField)

        XCTAssertTrue(viewController.sendButton.isEnabled)
    }

    func testTextDidChangeWithEmptyText() {
        viewController.messageTextField.text = ""
        viewController.textDidChange(textField: viewController.messageTextField)

        XCTAssertFalse(viewController.sendButton.isEnabled)
    }

    func testKeyboardWillBeShownNotification() {
        let expectedKeyboardHeight: CGFloat = 300
        let mockRect = CGRect(x: 0, y: 0, width: 0, height: expectedKeyboardHeight)
        let mockNotification = Notification(
            name: Notification.Name.NSCalendarDayChanged,
            object: nil,
            userInfo: [UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: mockRect)]
        )

        viewController.keyboardWillBeShown(notification: mockNotification)

        XCTAssertEqual(
            viewController.messageInputContainerViewBottomConstraints.constant,
            -expectedKeyboardHeight
        )
    }

    func testKeyboardWillBeHiddenNotification() {
        viewController.keyboardWillBeHidden(
            notification: Notification(name: Notification.Name.NSCalendarDayChanged)
        )

        XCTAssertEqual(viewController.messageInputContainerViewBottomConstraints.constant, 0.0)
    }

    func testTableViewDataSourceNumberOfRowInSection() {
        let expectedNumberOfMessage = 30
        mockOutput.mockNumberOfMessages = expectedNumberOfMessage
        let numberOfMessage = viewController.tableView(viewController.tableView, numberOfRowsInSection: 0)

        XCTAssertTrue(mockOutput.isCalled(.numberOfMessages))
        XCTAssertEqual(numberOfMessage, expectedNumberOfMessage)
    }

    func testTableViewDataSourceCellForRowAtIndexPathWithUserMessage() {
        mockOutput.shouldReturnUserMessage = true
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        let cellResult = viewController.tableView(
            viewController.tableView,
            cellForRowAt: expectedIndexPath
        )

        XCTAssertTrue(mockOutput.isCalled(.chatMessage(indexPath: expectedIndexPath)))
        XCTAssertTrue(cellResult is SenderMessageCell)

    }

    func testTableViewDataSourceCellForRowAtIndexPathWithEchoMessage() {
        mockOutput.shouldReturnUserMessage = false
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        let cellResult = viewController.tableView(
            viewController.tableView,
            cellForRowAt: expectedIndexPath
        )

        XCTAssertTrue(mockOutput.isCalled(.chatMessage(indexPath: expectedIndexPath)))
        XCTAssertTrue(cellResult is EchoMessageCell)

    }
}
