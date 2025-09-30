//
//  AlertView.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 25.09.2025.
//

import UIKit

final class AlertView: UIView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var tapOn: (() -> Void)?
    
    init(message: String, backgroundColor: UIColor?, image: UIImage?) {
        super.init(frame: .zero)
        setupUI(
            message: message,
            backgroundColor: backgroundColor,
            image: image
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(
        message: String,
        backgroundColor: UIColor?,
        image: UIImage?
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = backgroundColor ?? .red
        messageLabel.text = message
        imageView.image = image
        
        addSubview(containerView)
        containerView.addSubview(messageLabel)
        if image != nil {
            containerView.addSubview(imageView)
        }
        
        setupConstraints(hasImage: image != nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints(hasImage: Bool) {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.5)
        ])
        
        if hasImage {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 40),
                imageView.heightAnchor.constraint(equalToConstant: 40),
                
                messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
            ])
        } else {
            NSLayoutConstraint.activate([
                messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
                messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
            ])
        }
    }
    
    @objc private func dismiss() {
        tapOn?()
    }
}
