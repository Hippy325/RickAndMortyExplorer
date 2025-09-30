//
//  CharacterCell.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 26.09.2025.
//

import Foundation
import Combine
import UIKit

final class CharacterCell: UITableViewCell {

    private var cancellable: AnyCancellable?

    // MARK: - Subviews

    private let nameView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.numberOfLines = 0
        return label
    }()
    private let raceView = UILabel()
    private let statusView = UILabel()
    private let avatarView: LoadingImageView = {
        let imageView = LoadingImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return imageView
    }()
    
    private lazy var customBackgroundView: UIView = {
        let view = UIView()
        view.addSubview(nameView)
        view.addSubview(raceView)
        view.addSubview(statusView)
        view.addSubview(avatarView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.applyShadow(cornerRadius: 8)
        return view
    }()

    func configure(item: CharacterItem) {
        raceView.text = item.race
        statusView.text = item.status.rawValue
        nameView.text = item.name
        setBackgroundColor(item.status)

        item.image {
            self.cancellable = $0
                .receive(on: DispatchQueue.main)
                .sink { self.avatarView.setImage($0) }
        }
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable = nil
        avatarView.image = nil
        avatarView.startLoading()
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(customBackgroundView)

        setupLayout()
        avatarView.startLoading()
    }
    
    private func setBackgroundColor(_ status: CharacterItem.Status) {
        switch status {
        case .alive:
            customBackgroundView.backgroundColor = .green
        case .dead:
            customBackgroundView.backgroundColor = .red
        case .unowned:
            customBackgroundView.backgroundColor = .gray
            
        }
    }

    private func setupLayout() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        nameView.translatesAutoresizingMaskIntoConstraints = false
        raceView.translatesAutoresizingMaskIntoConstraints = false
        statusView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            customBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            customBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            customBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            customBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            avatarView.topAnchor.constraint(equalTo: customBackgroundView.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 100),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.bottomAnchor.constraint(equalTo: customBackgroundView.bottomAnchor),

            nameView.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: 4),
            nameView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            nameView.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -8),

            raceView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 5),
            raceView.leadingAnchor.constraint(equalTo: nameView.leadingAnchor),

            statusView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 5),
            statusView.leadingAnchor.constraint(equalTo: raceView.trailingAnchor, constant: 4),
        ])
    }
}
