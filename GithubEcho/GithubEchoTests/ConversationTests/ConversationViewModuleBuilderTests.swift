import XCTest

@testable import GithubEcho

final class ConversationViewModuleBuilderTests: XCTestCase {
    func testBuildModule() {
        let builder = ConversationViewModuleBuilder()

        let result = builder.build(
            people: GithubUser(username: "sample", imageURL: "sampleImage")
        )

        guard let viewController = result as? ConversationViewController else {
            return XCTFail("ConversationViewController is built incorrectly")
        }

        guard let presenter = viewController.output as? ConversationViewPresenter else {
            return XCTFail("ConversationViewPresenter is connected incorrectly")
        }

        XCTAssertNotNil(presenter.view)
    }
}
