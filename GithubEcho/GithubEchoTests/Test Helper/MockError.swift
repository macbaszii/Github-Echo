import Foundation

final class MockError {
    static let mockError = NSError(
        domain: "com.macbaszii",
        code: 404,
        userInfo: [NSLocalizedDescriptionKey: "mock error"]
    )
}
