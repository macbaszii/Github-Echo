import UIKit

extension UIViewController {
    func removeBackButtonTitleOnNextScreen() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
