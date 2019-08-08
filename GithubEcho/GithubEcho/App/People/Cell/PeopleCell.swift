import UIKit

final class PeopleCell: UITableViewCell, NibLoadable, ConfigurableCell {
    typealias NibRootType = PeopleCell

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    func configureCell(with viewModel: Any) {
        guard let viewModel = viewModel as? PeopleCellViewModel else { return }
        if let url = URL(string: viewModel.avatarURL) {
            avatarImageView.setImage(with: url)
        }
        usernameLabel.text = "@\(viewModel.username)"
    }
}

struct PeopleCellViewModel {
    let avatarURL: String
    let username: String
}

