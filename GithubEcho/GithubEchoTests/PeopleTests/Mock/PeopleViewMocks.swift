import XCTest
@testable import GithubEcho

final class MockPeopleViewOutput: PeopleViewOutput, MockInvocable {
    var invocations: [Invocation] = []

    enum Invocation: MockInvocationEnum {
        case viewIsReady
        case numberOfPeople
        case people(indexPath: IndexPath)
        case didSelectPeople(indexPath: IndexPath)
    }

    func viewIsReady() {
        invocations.append(.viewIsReady)
    }

    var mockNumberOfPeople = 10
    func numberOfPeople() -> Int {
        invocations.append(.numberOfPeople)
        return mockNumberOfPeople
    }

    var mockGithubUser = GithubUser(
        username: "macbaszii",
        imageURL: "https://avatars1.githubusercontent.com/u/809559?s=400&u=2ce17ff47064043e7892e9b421cea7ab4300e4bb&v=4"
    )

    func people(at indexPath: IndexPath) -> GithubUser {
        invocations.append(.people(indexPath: indexPath))
        return mockGithubUser
    }

    func didSelectPeople(at indexPath: IndexPath) {
        invocations.append(.didSelectPeople(indexPath: indexPath))
    }
}

final class MockConvesationBuildable: ConversationViewModuleBuildable, MockInvocable {
    var invocations: [Invocation] = []

    enum Invocation: MockInvocationEnum {
        case build(peopel: GithubUser)
    }

    func build(people: GithubUser) -> UIViewController {
        invocations.append(.build(peopel: people))
        return UIViewController()
    }
}

final class MockPeopleViewInteractorOutput: PeopleViewInteractorOutput, MockInvocable {
    var invocations: [Invocation] = []

    enum Invocation: MockInvocationEnum {
        case didReceivePeople(people: [GithubUser])
        case didReceiveError(message: String)
    }

    func didReceivePeople(_ people: [GithubUser]) {
        invocations.append(.didReceivePeople(people: people))
    }

    func didReceiveError(_ message: String) {
        invocations.append(.didReceiveError(message: message))
    }
}

final class MockGithubAPIClient: GithubAPIClient, MockInvocable {
    var invocations: [Invocation] = []

    enum Invocation: MockInvocationEnum {
        case getUsers
    }

    var  shouldGetSuccessResult = true
    func getUsers(completion: @escaping (Result<[GithubUser]>) -> Void) {
        invocations.append(.getUsers)

        if shouldGetSuccessResult {
            completion(.success([]))
        } else {
            completion(.failure(MockError.mockError))
        }
    }
}

final class MockPeopleViewInput: PeopleViewInput, MockInvocable {
    var invocations: [Invocation] = []

    enum Invocation: MockInvocationEnum {
        case updateDataSource
        case showLoadingView
        case hideLoadingView
    }

    func updateDataSource() {
        invocations.append(.updateDataSource)
    }

    func showLoadingView() {
        invocations.append(.showLoadingView)
    }

    func hideLoadingView() {
        invocations.append(.hideLoadingView)
    }
}

final class MockPeopleViewRouterInput: PeopleViewRouterInput, MockInvocable {
    var invocations: [Invocation] = []

    enum Invocation: MockInvocationEnum {
        case navigateToConversation(people: GithubUser)
        case showAlert
    }

    func navigateToConversation(for people: GithubUser) {
        invocations.append(.navigateToConversation(people: people))
    }

    func showAlert(_ alert: UIAlertController) {
        invocations.append(.showAlert)
    }
}

final class MockAlertBuildable: AlertBuildable, MockInvocable {
    var invocations: [Invocation] = []

    enum Invocation: MockInvocationEnum {
        case buildAlertView
    }

    func buildAlertView(title: String?, message: String?, proceedButtonTitle: String?, cancelButtonTitle: String?, proceedCompletion: (() -> Void)?, cancelCompletion: (() -> Void)?) -> UIAlertController {
        invocations.append(.buildAlertView)
        return UIAlertController(title: "", message: "", preferredStyle: .alert)
    }
}

final class MockPeopleViewInteractorInput: PeopleViewInteractorInput, MockInvocable {
    var invocations: [Invocation] = []

    enum Invocation: MockInvocationEnum {
        case fetchPeople
    }

    func fetchPeople() {
        invocations.append(.fetchPeople)
    }
}
