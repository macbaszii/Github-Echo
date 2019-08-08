import UIKit

class SenderMessageCell: UITableViewCell, ConfigurableCell {

    @IBOutlet weak var messageLabel: UILabel!

    func configureCell(with viewModel: Any) {
        guard let viewModel = viewModel as? MessageCellViewModel else { return }
        self.messageLabel.text = viewModel.message
    }
}
