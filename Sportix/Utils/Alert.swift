//
//  Alert.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 12/05/2026.
//

import UIKit

struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: (() -> Void)?

    init(title: String, style: UIAlertAction.Style = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

final class AlertManager {

    private init() {}

    static func show(
        on viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertController.Style = .alert,
        actions: [AlertAction],
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        for action in actions {
            let uiAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler?()
            }
            alert.addAction(uiAction)
        }

        DispatchQueue.main.async {
            viewController.present(alert, animated: animated, completion: completion)
        }
    }

    static func showOK(
        on viewController: UIViewController,
        title: String?,
        message: String?,
        okTitle: String = "OK",
        handler: (() -> Void)? = nil
    ) {
        show(
            on: viewController,
            title: title,
            message: message,
            actions: [AlertAction(title: okTitle, style: .default, handler: handler)]
        )
    }

    static func showConfirmation(
        on viewController: UIViewController,
        title: String?,
        message: String?,
        confirmTitle: String = "Confirm",
        confirmStyle: UIAlertAction.Style = .default,
        cancelTitle: String = "Cancel",
        onConfirm: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        let actions: [AlertAction] = [
            AlertAction(title: confirmTitle, style: confirmStyle, handler: onConfirm),
            AlertAction(title: cancelTitle, style: .cancel, handler: onCancel)
        ]
        show(on: viewController, title: title, message: message, actions: actions)
    }

    static func showDestructive(
        on viewController: UIViewController,
        title: String?,
        message: String?,
        destructiveTitle: String = "Delete",
        cancelTitle: String = "Cancel",
        onDestruct: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        showConfirmation(
            on: viewController,
            title: title,
            message: message,
            confirmTitle: destructiveTitle,
            confirmStyle: .destructive,
            cancelTitle: cancelTitle,
            onConfirm: onDestruct,
            onCancel: onCancel
        )
    }

    static func showError(
        on viewController: UIViewController,
        error: Error,
        retryHandler: (() -> Void)? = nil
    ) {
        var actions: [AlertAction] = [AlertAction(title: "OK", style: .cancel)]
        if let retry = retryHandler {
            actions.insert(AlertAction(title: "Retry", style: .default, handler: retry), at: 0)
        }
        show(
            on: viewController,
            title: "Error",
            message: error.localizedDescription,
            actions: actions
        )
    }

    static func showActionSheet(
        on viewController: UIViewController,
        title: String?,
        message: String?,
        actions: [AlertAction],
        cancelTitle: String = "Cancel",
        sourceView: UIView? = nil
    ) {
        var allActions = actions
        allActions.append(AlertAction(title: cancelTitle, style: .cancel))

        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        allActions.forEach { action in
            alert.addAction(UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler?()
            })
        }

        if let popover = alert.popoverPresentationController {
            popover.sourceView = sourceView ?? viewController.view
            popover.sourceRect = sourceView?.bounds ?? viewController.view.bounds
        }

        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }

    static func showTextInput(
        on viewController: UIViewController,
        title: String?,
        message: String?,
        placeholder: String? = nil,
        initialText: String? = nil,
        keyboardType: UIKeyboardType = .default,
        confirmTitle: String = "OK",
        cancelTitle: String = "Cancel",
        onConfirm: ((String) -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = initialText
            textField.keyboardType = keyboardType
            textField.autocorrectionType = .no
        }

        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            let text = alert.textFields?.first?.text ?? ""
            onConfirm?(text)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            onCancel?()
        }

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
}

extension UIViewController {

    func showAlert(title: String?, message: String?, actions: [AlertAction]) {
        AlertManager.show(on: self, title: title, message: message, actions: actions)
    }

    func showOKAlert(title: String?, message: String?, handler: (() -> Void)? = nil) {
        AlertManager.showOK(on: self, title: title, message: message, handler: handler)
    }

    func showConfirmationAlert(
        title: String?,
        message: String?,
        confirmTitle: String = "Confirm",
        onConfirm: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        AlertManager.showConfirmation(
            on: self,
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            onConfirm: onConfirm,
            onCancel: onCancel
        )
    }

    func showErrorAlert(error: Error, retryHandler: (() -> Void)? = nil) {
        AlertManager.showError(on: self, error: error, retryHandler: retryHandler)
    }
}
