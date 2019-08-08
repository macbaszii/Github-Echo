import UIKit

final class PeopleViewController: UIViewController, NibLoadable {
    typealias NibRootType = PeopleViewController

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var output: PeopleViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        output?.viewIsReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Private
    private func setupView() {
        title = "Github DM"
        removeBackButtonTitleOnNextScreen()
        loadingIndicator.hidesWhenStopped = true
        loadingView.isHidden = true

        setupTableView()
    }

    private func setupTableView() {
        let peopleCellNib = UINib(
            nibName: CellIdentifiers.PeopleViewModule.peopleCell,
            bundle: Bundle(for: PeopleCell.self)
        )

        tableView.register(
            peopleCellNib,
            forCellReuseIdentifier: CellIdentifiers.PeopleViewModule.peopleCell
        )
    }
}

// MARK: - PeopleViewInput
extension PeopleViewController: PeopleViewInput {
    func updateDataSource() {
        tableView.reloadData()
    }

    func showLoadingView() {
        loadingView.isHidden = false
        loadingIndicator.startAnimating()
    }

    func hideLoadingView() {
        loadingView.isHidden = true
        loadingIndicator.stopAnimating()
    }
}

// MARK: - UITableViewDataSource
extension PeopleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.numberOfPeople() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PeopleCell.self),
            for: indexPath
        ) as? PeopleCell else { return UITableViewCell() }

        guard let currentPeople = output?.people(at: indexPath) else {
            return UITableViewCell()
        }

        let viewModel = PeopleCellViewModel(
            avatarURL: currentPeople.imageURL,
            username: currentPeople.username
        )

        cell.configureCell(with: viewModel)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension PeopleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didSelectPeople(at: indexPath)
    }
}
