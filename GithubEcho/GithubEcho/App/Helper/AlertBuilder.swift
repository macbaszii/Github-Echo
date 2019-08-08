import UIKit

protocol AlertBuildable {
    func buildAlertView(title: String?,
                        message: String?,
                        proceedButtonTitle: String?,
                        cancelButtonTitle: String?,
                        proceedCompletion: (() -> Void)?,
                        cancelCompletion: (() -> Void)?) -> UIAlertController
}

final class AlertBuilder: AlertBuildable {
    func buildAlertView(title: String?,
                        message: String?,
                        proceedButtonTitle: String?,
                        cancelButtonTitle: String?,
                        proceedCompletion: (() -> Void)?,
                        cancelCompletion: (() -> Void)?) -> UIAlertController {

        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let proceedAction = UIAlertAction(
            title: proceedButtonTitle,
            style: .default) { _ in
                proceedCompletion?()
        }
        alert.addAction(proceedAction)

        if let cancelButtonTitle = cancelButtonTitle {
            let cancelaction = UIAlertAction(
                title: cancelButtonTitle,
                style: .cancel) { _ in
                    cancelCompletion?()
            }
            alert.addAction(cancelaction)
        }

        return alert
    }
}
