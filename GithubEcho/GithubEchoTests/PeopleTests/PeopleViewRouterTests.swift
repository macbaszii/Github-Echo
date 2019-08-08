import XCTest

@testable import GithubEcho

final class PeopleViewRouterTests: XCTestCase {
    var router: PeopleViewRouter!
    var mockConversationBuilder: MockConvesationBuildable!
    var mockViewController: MockViewController!
    var mockNavigationController: MockNavigationController!

    override func setUp() {
        super.setUp()

        mockViewController = MockViewController()
        mockNavigationController = MockNavigationController(
            rootViewController: mockViewController
        )
        mockConversationBuilder = MockConvesationBuildable()

        router = PeopleViewRouter(
            conversationBuilder: mockConversationBuilder
        )

        router.parentViewController = mockViewController
    }

    override func tearDown() {
        router = nil
        mockConversationBuilder = nil

        super.tearDown()
    }

    func testNavigationToConversation() {
        let expectedUser = GithubUser(
            username: "example",
            imageURL: "https://www.google.com/macbaszii.jpg"
        )

        router.navigateToConversation(for: expectedUser)

        XCTAssertTrue(mockConversationBuilder.isCalledWithParameter(.build(peopel: expectedUser)))
        XCTAssertTrue(mockNavigationController.isCalled(.pushViewController))
    }

    func testShowAlert() {
        router.showAlert(UIAlertController(
            title: "",
            message: "",
            preferredStyle: .alert
        ))

        XCTAssertTrue(mockViewController.isCalled(.present))
    }
}
