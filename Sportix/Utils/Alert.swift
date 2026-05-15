//
//  Alert.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 12/05/2026.
//

import UIKit

extension UIViewController {
    
    func showToast(message: String, iconName: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let toastContainer = UIView()
        toastContainer.backgroundColor = UIColor(white: 0.15, alpha: 0.95)
        toastContainer.layer.cornerRadius = 20
        toastContainer.clipsToBounds = true
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        messageLabel.textAlignment = .natural
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, messageLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        toastContainer.addSubview(stackView)
        window.addSubview(toastContainer)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -12),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            toastContainer.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            toastContainer.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
        
        toastContainer.alpha = 0.0
        toastContainer.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            toastContainer.alpha = 1.0
            toastContainer.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseIn, animations: {
                toastContainer.alpha = 0.0
                toastContainer.transform = CGAffineTransform(translationX: 0, y: 20)
            }) { _ in
                toastContainer.removeFromSuperview()
            }
        }
    }
    
    func showConfirmation(
        title: String?,
        message: String?,
        confirmTitle: String = "Confirm",
        cancelTitle: String = "Cancel",
        isDestructive: Bool = false,
        onConfirm: @escaping () -> Void
    ) {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let overlayView = UIView(frame: window.bounds)
        overlayView.backgroundColor = AppTheme.Colors.background
        overlayView.alpha = 0.5
        
        let alertView = UIView()
        alertView.backgroundColor = AppTheme.Colors.card
        alertView.layer.cornerRadius = 24
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconName = isDestructive ? "exclamationmark.triangle.fill" : "exclamationmark.circle.fill"
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = isDestructive ? .systemRed : .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.backgroundColor = AppTheme.Colors.background
        cancelButton.layer.cornerRadius = 14
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle(confirmTitle, for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = isDestructive ? .systemRed : .systemBlue
        confirmButton.layer.cornerRadius = 14
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.addSubview(iconImageView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(buttonStack)
        overlayView.addSubview(alertView)
        window.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            alertView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 320),
            
            iconImageView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 24),
            iconImageView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            iconImageView.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -24),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -24),
            
            buttonStack.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            buttonStack.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 24),
            buttonStack.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -24),
            buttonStack.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -24),
            buttonStack.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        alertView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            overlayView.alpha = 1
            alertView.transform = .identity
        })
        
        func dismissAlert() {
            UIView.animate(withDuration: 0.2, animations: {
                overlayView.alpha = 0
                alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                overlayView.removeFromSuperview()
            }
        }
        
        cancelButton.addAction(UIAction { _ in dismissAlert() }, for: .touchUpInside)
        confirmButton.addAction(UIAction { _ in
            dismissAlert()
            onConfirm()
        }, for: .touchUpInside)
    }

    func showAlert(title: String, message: String, type: AlertType = .warning) {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }

        let overlayView = UIView(frame: window.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.alpha = 0

        let alertView = UIView()
        alertView.backgroundColor = .systemBackground
        alertView.layer.cornerRadius = 24
        alertView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView(image: UIImage(systemName: type.iconName))
        iconImageView.tintColor = type.color
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        let okButton = UIButton(type: .system)
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = type.color
        okButton.layer.cornerRadius = 14
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        okButton.translatesAutoresizingMaskIntoConstraints = false

        alertView.addSubview(iconImageView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(okButton)
        overlayView.addSubview(alertView)
        window.addSubview(overlayView)

        NSLayoutConstraint.activate([
            alertView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 320),

            iconImageView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 24),
            iconImageView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            iconImageView.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -24),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -24),

            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            okButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 24),
            okButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -24),
            okButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -24),
            okButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        alertView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            overlayView.alpha = 1
            alertView.transform = .identity
        })

        func dismissAlert() {
            UIView.animate(withDuration: 0.2, animations: {
                overlayView.alpha = 0
                alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                overlayView.removeFromSuperview()
            }
        }

        okButton.addAction(UIAction { _ in dismissAlert() }, for: .touchUpInside)
    }
}

enum AlertType {
    case warning
    case error

    var iconName: String {
        switch self {
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        }
    }

    var color: UIColor {
        switch self {
        case .warning: return .systemOrange
        case .error: return .systemRed
        }
    }
}
