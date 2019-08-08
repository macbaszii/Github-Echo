import XCTest

@testable import GithubEcho

final class PeopleViewControllerTests: XCTestCase {

    var viewController: PeopleViewController!
    var mockOutput: MockPeopleViewOutput!

    override func setUp() {
        super.setUp()
        do {
            viewController = try PeopleViewController.loadFromNib()
        } catch {
            XCTFail("Couldn't load PeopleViewController from nib file")
        }

        mockOutput = MockPeopleViewOutput()

        viewController.output = mockOutput
        XCTAssertNotNil(viewController.view) // -viewDidLoad will be triggered here
    }

    override func tearDown() {
        viewController = nil
        mockOutput = nil

        super.tearDown()
    }

    func testViewDidLoad() {
        XCTAssertEqual(viewController.title, "Github DM")
        XCTAssertTrue(mockOutput.isCalled(.viewIsReady))
        XCTAssertTrue(viewController.loadingView.isHidden)
    }

    func testShowLoadingView() {
        viewController.showLoadingView()

        XCTAssertFalse(viewController.loadingView.isHidden)
    }

    func testHideLoadingView() {
        viewController.hideLoadingView()

        XCTAssertTrue(viewController.loadingView.isHidden)
    }

    func testTableViewDataSourceNumberOfRowInSection() {
        let expectedResult = mockOutput.mockNumberOfPeople
        let result = viewController.tableView(viewController.tableView, numberOfRowsInSection: 0)

        XCTAssertTrue(mockOutput.isCalled(.numberOfPeople))
        XCTAssertEqual(expectedResult, result)
    }

    func testTableViewDataSourceCellForRowAtIndexPath() {
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        let cellResult = viewController.tableView(
            viewController.tableView,
            cellForRowAt: expectedIndexPath
        )

        XCTAssertTrue(mockOutput.isCalled(.people(indexPath: expectedIndexPath)))
        XCTAssertTrue(cellResult is PeopleCell)
    }

    func testTableViewDelegateDidSelectCellAtIndexPath() {
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        viewController.tableView(viewController.tableView, didSelectRowAt: expectedIndexPath)

        XCTAssertTrue(mockOutput.isCalledWithParameter(.didSelectPeople(indexPath: expectedIndexPath)))
    }
}
