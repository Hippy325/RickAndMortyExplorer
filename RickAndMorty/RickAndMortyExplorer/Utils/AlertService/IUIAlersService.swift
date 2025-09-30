//
//  IUIAlertService.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 25.09.2025.
//

import UIKit

protocol IUIAlersService: AnyObject {
    func show(message: String, backgroundColor: UIColor?, image: UIImage?)
}

extension IUIAlersService {
    func show(message: String, backgroundColor: UIColor? = nil, image: UIImage? = nil) {
        show(message: message, backgroundColor: backgroundColor, image: image)
    }
}
