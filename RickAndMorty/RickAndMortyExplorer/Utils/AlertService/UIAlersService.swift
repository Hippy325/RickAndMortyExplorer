//
//  UIAlersService.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 25.09.2025.
//

import UIKit

final class UIAlersService: IUIAlersService {
    
    private var alertView: AlertView?
    
    func show(message: String, backgroundColor: UIColor?, image: UIImage?) {
        guard let window = UIApplication.shared.windows.last else { return }
        let alertView = AlertView(
            message: message,
            backgroundColor: backgroundColor,
            image: image
        )
        window.addSubview(alertView)
        self.alertView = alertView
        NSLayoutConstraint.activate([
            alertView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            alertView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            alertView.topAnchor.constraint(equalTo: window.topAnchor),
            alertView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
        window.isHidden = false
        alertView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            alertView.alpha = 1
        }
        alertView.tapOn = hide
    }
    
    private func hide() {
        guard let window = UIApplication.shared.windows.last else { return }
        guard let alertView = alertView else { return }
        UIView.animate(withDuration: 0.3, animations: {
            alertView.alpha = 0
        }) { [weak self] _ in
            alertView.removeFromSuperview()
            window.isHidden = true
            self?.alertView = nil
        }
    }
}
