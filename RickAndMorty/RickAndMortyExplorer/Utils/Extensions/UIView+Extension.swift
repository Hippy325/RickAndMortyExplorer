//
//  UIView+Extension.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 29.09.2025.
//

import UIKit

extension UIView {
    func applyShadow(
        cornerRadius: CGFloat = 0,
        shadowColor: UIColor = .black,
        shadowRadius: CGFloat = 5.0,
        shadowOpacity: Float = 0.5,
        shadowOffset: CGSize = CGSize(width: 0, height: 2)
    ) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
    }
}
