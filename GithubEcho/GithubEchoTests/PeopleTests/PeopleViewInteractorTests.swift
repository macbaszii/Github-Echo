import XCTest

@testable import GithubEcho

final class PeopleViewInteractorTests: XCTestCase {
    var mockAPIClient: MockGithubAPIClient!
    var mockOutput: MockPeopleViewInteractorOutput!
    var interactor: PeopleViewInteractor!

    override func setUp() {
        super.setUp()

        mockAPIClient = MockGithubAPIClient()
        mockOutput = MockPeopleViewInteractorOutput()
        interactor = PeopleViewInteractor(
            apiClient: mockAPIClient
        )

        interactor.output = mockOutput
    }

    override func tearDown() {
        mockAPIClient = nil
        mockOutput = nil
        interactor = nil

        super.tearDown()
    }

    func testFetchPeople() {
        mockAPIClient.shouldGetSuccessResult = true
        interactor.fetchPeople()

        XCTAssertTrue(mockAPIClient.isCalled(.getUsers))
        XCTAssertTrue(mockOutput.isCalled(.didReceivePeople(people: [])))
    }

    func testFetchPeopleFailed() {
        mockAPIClient.shouldGetSuccessResult = false
        interactor.fetchPeople()

        XCTAssertTrue(mockAPIClient.isCalled(.getUsers))
        XCTAssertTrue(mockOutput.isCalled(.didReceiveError(message: "")))
    }
}
