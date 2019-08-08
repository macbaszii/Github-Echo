import XCTest

@testable import GithubEcho

final class PeopleViewModuleBuilderTests: XCTestCase {
    func testBuildModule() {
        let builder = PeopleViewModuleBuilder()

        let viewController = builder.build()

        guard let view = viewController as? PeopleViewController else {
            return XCTFail("PeopleViewController is built incorrectly")
        }

        guard let presenter = view.output as? PeopleViewPresenter else {
            return XCTFail("PeopleViewPresenter is connected incorrectly")
        }

        XCTAssertNotNil(presenter.view)

        guard let interactor = presenter.interactor as? PeopleViewInteractor else {
            return XCTFail("PeopleViewInteractor is connected incorrectly")
        }

        XCTAssertNotNil(interactor.output)

        guard let router = presenter.router as? PeopleViewRouter else {
            return XCTFail("PeopleViewRouter is connected incorrectly")
        }

        XCTAssertNotNil(router.parentViewController)
    }
}
