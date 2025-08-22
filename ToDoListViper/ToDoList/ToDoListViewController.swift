//
//  ToDoListViewController.swift
//  ToDoListViper
//
//  Created by Mariya Slepneva on 15.08.2025.
//

import UIKit

class ToDoListViewController: UIViewController {

    // MARK: - Internal Properties

    var presenter: ToDoListPresenterProtocol!

    // MARK: - Private Properties

    private let searchController = UISearchController()
    private let toDoListTableView = UITableView(frame: .zero, style: .plain)
    private let tasksCountText = UIBarButtonItem()
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupToDoListTableView()
        setupBottomToolbar()
        setupHomeIndicatorBackground()
        setupSearchController()
        setupObservers()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.overrideUserInterfaceStyle = .dark
        overrideUserInterfaceStyle = .dark
    }

    private func setupToDoListTableView() {
        toDoListTableView.dataSource = self
        toDoListTableView.delegate = self
        toDoListTableView.register(ToDoListTaskViewCell.self, forCellReuseIdentifier: ToDoListTaskViewCell.identifier)

        view.addSubview(toDoListTableView)

        toDoListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toDoListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            toDoListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toDoListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toDoListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupBottomToolbar() {
        tasksCountText.isEnabled = false
        tasksCountText.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11),
                NSAttributedString.Key.foregroundColor : UIColor.white
            ],
            for: .disabled
        )

        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(addTaskTapped)
        )

        toolbarItems = [flexibleSpace, tasksCountText, flexibleSpace, addButton]
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.toolbar.backgroundColor = .systemGray6
    }

    private func setupHomeIndicatorBackground() {
        let indicatorBackgroundView = UIView()
        indicatorBackgroundView.backgroundColor = .systemGray6
        view.addSubview(indicatorBackgroundView)

        indicatorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicatorBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            indicatorBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicatorBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataUpdate),
            name: .didUpdateTask,
            object: nil
        )
    }

    @objc private func addTaskTapped() {
        presenter.shouldOpenTaskEdition(currentTask: nil)
    }
    
    @objc private func handleDataUpdate() {
        presenter.updateData()
    }
}

// MARK: - UITableViewDataSource

extension ToDoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.tasksCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTaskViewCell.identifier) as? ToDoListTaskViewCell else {
            return UITableViewCell()
        }
        cell.apply(configuration: presenter.getCellConfiguration(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, actionProvider: { _ in
            let edit = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "square.and.pencil")) { _ in
                    self.presenter.shouldOpenTaskEdition(currentTask: self.presenter.getCurrentTask(by: indexPath))
                }
            let share = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    self.presenter.shouldOpenActivityViewController(at: indexPath)
                }
            let delete = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                    self.presenter.deleteItem(at: indexPath)
                }
            return UIMenu(children: [edit, share, delete])
        })
    }
}

// MARK: - UITableViewDelegate

extension ToDoListViewController: UITableViewDelegate {

}

// MARK: - ToDoListViewProtocol

extension ToDoListViewController: ToDoListViewProtocol {

    func reloadToDoList() {
        toDoListTableView.reloadData()
    }
    
    func updateTask(at indexPath: IndexPath) {
        toDoListTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }

    func setTasksCountText(_ text: String) {
        tasksCountText.title = text
    }
}

extension ToDoListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        presenter.updateSearchResult(query: searchController.searchBar.text ?? "")
    }
}

// MARK: - Constants

private enum Constants {

}
