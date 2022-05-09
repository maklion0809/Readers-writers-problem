//
//  TableViewController.swift
//  Task10Concurrency&multithreading
//
//  Created by Tymofii (Work) on 19.10.2021.
//

import UIKit

final class TableViewController: UIViewController {
    
    // MARK: - Configuration
    
    private enum Configuration {
        static let cellIdentifier = "Cell"
    }
    
    // MARK: - UI element
    
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var addBarButton: UIBarButtonItem = {
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(wasAddButtonTapped(_:)))
        return addButtonItem
    }()
    
    // MARK: - Variable
    
    private var readerWriter = ReaderWriter<String>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        setupConstraint()
        setupTableView()
    }
    
    // MARK: - Setting up the constraint
    
    private func setupConstraint() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Setting up the tableView
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Configuration.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        title = "To do list"
        navigationItem.rightBarButtonItem = addBarButton
        navigationItem.prompt = readerWriter.elements.count > 0 ? nil : "You can add item!"
    }
    
    // MARK: - UIAction
    
    @objc private func wasAddButtonTapped(_ sender: UITabBarItem) {
        let alert = UIAlertController(title: "To do list", message: "Аdd a note", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter a note"
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            guard let self = self, let text = alert.textFields?.first?.text else { return }
            self.readerWriter.insert(text)
            if self.readerWriter.elements.count == 1{
                DispatchQueue.main.async {
                    self.navigationItem.prompt = nil
                    self.navigationController?.viewIfLoaded?.setNeedsLayout()
                }
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        readerWriter.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Configuration.cellIdentifier) else { return UITableViewCell() }
        cell.textLabel?.text = readerWriter.elements[indexPath.item]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
