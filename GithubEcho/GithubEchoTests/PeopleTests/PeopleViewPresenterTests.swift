import XCTest

@testable import GithubEcho

class PeopleViewPresenterTests: XCTestCase {
    var presenter: PeopleViewPresenter!
    var mockView: MockPeopleViewInput!
    var mockInteractor: MockPeopleViewInteractorInput!
    var mockRouter: MockPeopleViewRouterInput!
    var mockAlertBuilder: MockAlertBuildable!

    override func setUp() {
        super.setUp()

        mockView = MockPeopleViewInput()
        mockInteractor = MockPeopleViewInteractorInput()
        mockRouter = MockPeopleViewRouterInput()
        mockAlertBuilder = MockAlertBuildable()

        presenter = PeopleViewPresenter(alertBuilder: mockAlertBuilder)
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }

    override func tearDown() {
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        mockAlertBuilder = nil
        presenter = nil

        super.tearDown()
    }

    func testViewIsReady() {
        presenter.viewIsReady()

        XCTAssertTrue(mockView.isCalled(.showLoadingView))
        XCTAssertTrue(mockInteractor.isCalled(.fetchPeople))
    }

    func testGetNumberOfPeople() {
        let user1 = GithubUser(username: "people 1", imageURL: "people 1 image")
        let user2 = GithubUser(username: "people 2", imageURL: "people 2 image")
        presenter.didReceivePeople([user1, user2])

        let result = presenter.numberOfPeople()

        XCTAssertEqual(result, 2)
    }

    func testGetPeopleAtIndexPath() {
        let user1 = GithubUser(username: "people 1", imageURL: "people 1 image")
        let user2 = GithubUser(username: "people 2", imageURL: "people 2 image")
        presenter.didReceivePeople([user1, user2])

        let result = presenter.people(at: IndexPath(row: 0, section: 0))

        XCTAssertEqual(result.username, "people 1")
        XCTAssertEqual(result.imageURL, "people 1 image")
    }

    func testDidSelectPeopleAtIndexPath() {
        let user1 = GithubUser(username: "people 1", imageURL: "people 1 image")
        let user2 = GithubUser(username: "people 2", imageURL: "people 2 image")
        presenter.didReceivePeople([user1, user2])

        presenter.didSelectPeople(at: IndexPath(row: 1, section: 0))

        XCTAssertTrue(mockRouter.isCalled(.navigateToConversation(people: user2)))
    }

    func testDidReceivePeople() {
        let user1 = GithubUser(username: "people 1", imageURL: "people 1 image")
        let user2 = GithubUser(username: "people 2", imageURL: "people 2 image")
        presenter.didReceivePeople([user1, user2])

        XCTAssertTrue(mockView.isCalled(.hideLoadingView))
        XCTAssertTrue(mockView.isCalled(.updateDataSource))
    }

    func testDidReceiveError() {
        presenter.didReceiveError("error message")

        XCTAssertTrue(mockRouter.isCalled(.showAlert))
    }
}
