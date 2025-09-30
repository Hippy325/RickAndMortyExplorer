//
//  LoadingImageView.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 28.09.2025.
//

import UIKit

final class LoadingImageView: UIImageView {
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func setImage(_ image: UIImage?) {
        self.image = image
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
