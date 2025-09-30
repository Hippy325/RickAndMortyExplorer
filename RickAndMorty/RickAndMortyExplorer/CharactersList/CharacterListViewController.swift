//
//  CharacterListViewController.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 26.09.2025.
//

import UIKit
import Combine

class CharacterListViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var characterTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "CharacterCell")
        tableView.register(LoaderCell.self, forCellReuseIdentifier: "LoaderCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите имя персонажа"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.delegate = self
        textField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var statusSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All", "Alive", "Dead", "Unknown"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(statusChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Применить", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var store = Set<AnyCancellable>()
    private let viewModel: ICharacterListViewModel
    
    init(viewModel: ICharacterListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
        viewModel.send(.onAppear)
        
        viewModel.statePublisher
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .initialLoading:
                    self.loadingIndicator.startAnimating()
                    self.characterTableView.isHidden = true
                case .loaded:
                    self.loadingIndicator.stopAnimating()
                    self.characterTableView.isHidden = false
                    self.characterTableView.reloadData()
                }
            }
            .store(in: &store)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setup() {
        view.addSubview(characterTableView)
        view.addSubview(nameTextField)
        view.addSubview(statusSegmentedControl)
        view.addSubview(applyButton)
        view.addSubview(loadingIndicator)
        view.backgroundColor = .white
        
        setupLayout()
    }
    
    private func setupLayout() {
        characterTableView.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        statusSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            statusSegmentedControl.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            statusSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statusSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            applyButton.topAnchor.constraint(equalTo: statusSegmentedControl.bottomAnchor, constant: 16),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            applyButton.heightAnchor.constraint(equalToConstant: 48),
            
            characterTableView.topAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: 16),
            characterTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            characterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            characterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func statusChanged() {
        viewModel.send(.setStatusFilter(statusSegmentedControl.selectedSegmentIndex))
    }
    
    @objc private func applyFilters() {
        viewModel.send(.onApplyFilters)
    }
    
    @objc private func nameTextFieldChanged() {
        viewModel.send(.setNameFilter(nameTextField.text))
    }
}

extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.models[indexPath.row] {
        case .character(characterItem: let item):
            guard let characterCell = tableView.dequeueReusableCell(
                withIdentifier: "CharacterCell",
                for: indexPath
            ) as? CharacterCell else { return UITableViewCell() }
            characterCell.configure(item: item)
            return characterCell
        case .loader:
            guard let loaderCell = tableView.dequeueReusableCell(
                withIdentifier: "LoaderCell",
                for: indexPath
            ) as? LoaderCell else { return UITableViewCell() }
            loaderCell.startAnimation()
            return loaderCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.send(.onSelectCharacter(indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if tableView.visibleCells.contains(cell) {
                guard cell as? LoaderCell != nil else { return }
                self.viewModel.send(.onAppear)
            }
        }
    }
}

extension CharacterListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
