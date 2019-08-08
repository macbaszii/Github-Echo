import UIKit

final class ConversationViewController: UIViewController, NibLoadable, ConversationViewInput {
    typealias NibRootType = ConversationViewController

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageInputContainerViewBottomConstraints: NSLayoutConstraint!

    @IBAction func sendButtonTapped(_ button: UIButton) {
        output?.sendMessage(messageTextField.text ?? "")
    }

    var output: ConversationViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        output?.viewIsReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func updateTitle(_ title: String) {
        self.title = title
    }

    func reloadDataSource() {
        tableView.reloadData()
        tableView.scrollToRow(
            at: IndexPath(row: (output?.numberOfMessages() ?? 0) - 1, section: 0),
            at: .none,
            animated: true
        )
    }

    func clearInputField() {
        messageTextField.text = ""
    }

    func enableSendButton() {
        sendButton.isEnabled = true
    }

    func disableSendButton() {
        sendButton.isEnabled = false
    }
}

// MARK: - Private
extension ConversationViewController {
    private func setupView() {
        setupInputField()
        setupTableView()
        setupKeyboardNotifications()
    }

    private func setupInputField() {
        sendButton.isEnabled = false
        messageTextField.addTarget(
            self,
            action: #selector(textDidChange(textField:)),
            for: .editingChanged
        )
    }

    @objc func textDidChange(textField: UITextField) {
        sendButton.isEnabled = !(textField.text?.isEmpty ?? false)
    }

    private func setupTableView() {
        let senderMessageNib = UINib(
            nibName: CellIdentifiers.ConversationViewModule.senderMessageCell,
            bundle: Bundle(for: SenderMessageCell.self)
        )

        let echoMessageNib = UINib(
            nibName: CellIdentifiers.ConversationViewModule.echoMessageCell,
            bundle: Bundle(for: EchoMessageCell.self)
        )

        tableView.register(
            senderMessageNib,
            forCellReuseIdentifier: CellIdentifiers.ConversationViewModule.senderMessageCell
        )

        tableView.register(
            echoMessageNib,
            forCellReuseIdentifier: CellIdentifiers.ConversationViewModule.echoMessageCell
        )

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ConversationViewController.keyboardWillBeShown(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ConversationViewController.keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillBeShown(notification: Notification) {
        guard let keyboardFrameInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
            let keyboardHeight = (keyboardFrameInfo as? NSValue)?.cgRectValue.height else { return }
        messageInputContainerViewBottomConstraints.constant = -keyboardHeight
        view.needsUpdateConstraints()
        view.layoutIfNeeded()
    }

    @objc func keyboardWillBeHidden(notification: Notification) {
        messageInputContainerViewBottomConstraints.constant = 0
        view.needsUpdateConstraints()
        view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.numberOfMessages() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentMessage = output?.chatMessage(at: indexPath) else { return UITableViewCell() }

        switch currentMessage.type {
        case .userMessage:
            return createSenderMessageCell(
                for: tableView,
                with: currentMessage.message,
                at: indexPath
            )
        case .echoMessage:
            return createEchoMessageCell(
                for: tableView,
                with: currentMessage.message,
                at: indexPath
            )
        }
    }

    private func createSenderMessageCell(for tableView: UITableView,
                                         with message: String,
                                         at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentifiers.ConversationViewModule.senderMessageCell,
            for: indexPath
            ) as? SenderMessageCell else { return UITableViewCell() }

        let viewModel = MessageCellViewModel(message: message)
        cell.configureCell(with: viewModel)

        return cell
    }

    private func createEchoMessageCell(for tableView: UITableView,
                                       with message: String,
                                       at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentifiers.ConversationViewModule.echoMessageCell,
            for: indexPath
        ) as? EchoMessageCell else { return UITableViewCell() }

        let viewModel = MessageCellViewModel(message: message)
        cell.configureCell(with: viewModel)

        return cell
    }
}

// MARK: - UITextFieldDelegate
extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
