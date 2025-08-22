//
//  TaskEditionViewController.swift
//  ToDoListViper
//
//  Created by Mariya Slepneva on 17.08.2025.
//

import UIKit

final class TaskEditionViewController: UIViewController, Configurable {
    
    // MARK: - Nested types
    
    struct Configuration {

        let title: String
        let description: String
        let date: String
    }
    
    // MARK: - Internal Properties

    var presenter: TaskEditionPresenterProtocol!

    // MARK: - Private Properties

    private let scrollView = UIScrollView()
    private let container = UIView()
    private let taskTitleTextView = UITextView()
    private let taskDescriptionTextView = UITextView()
    private let dateLabel = UILabel()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupKeyboardObservers()
        setupScrollView()
        setupContainer()
        setupTaskTitleTextView()
        setupDateLabel()
        setupTaskDescriptionTextView()
        hideKeyboardWhenTappedAround()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        presenter.saveTask(
            title: taskTitleTextView.text,
            description: taskDescriptionTextView.text
        )
    }
    
    // MARK: - Private Methods
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(container)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupContainer() {
        container.addSubview(taskTitleTextView)
        container.addSubview(dateLabel)
        container.addSubview(taskDescriptionTextView)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    private func setupDateLabel() {
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = UIColor(named: "secondaryTextColor")
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: taskTitleTextView.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: taskDescriptionTextView.topAnchor, constant: -8)
        ])
    }

    private func setupTaskTitleTextView() {
        taskTitleTextView.font = .systemFont(ofSize: 34, weight: .bold)
        taskTitleTextView.delegate = self
        taskTitleTextView.returnKeyType = .done
        taskTitleTextView.isScrollEnabled = false
        taskTitleTextView.textContainer.lineFragmentPadding = 0

        taskTitleTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskTitleTextView.topAnchor.constraint(equalTo: container.topAnchor),
            taskTitleTextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            taskTitleTextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            taskTitleTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 42.0)
        ])
    }
    
    private func setupTaskDescriptionTextView() {
        taskDescriptionTextView.font = .systemFont(ofSize: 16, weight: .regular)
        taskDescriptionTextView.delegate = self
        taskDescriptionTextView.returnKeyType = .done
        taskDescriptionTextView.isScrollEnabled = false
        taskDescriptionTextView.textContainer.lineFragmentPadding = 0

        taskDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskDescriptionTextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            taskDescriptionTextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            taskDescriptionTextView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
    }
    
    private func findFirstResponder() -> UIView? {
        if taskTitleTextView.isFirstResponder {
            return taskTitleTextView
        } else if taskDescriptionTextView.isFirstResponder {
            return taskDescriptionTextView
        }
        return nil
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom + 8
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        if let firstResponder = findFirstResponder() {
            let rect = firstResponder.convert(firstResponder.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

extension TaskEditionViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeholder = textView === taskTitleTextView ? "Название" : "Описание"
        if textView.text == placeholder && textView.isFirstResponder {
            textView.text = ""
            textView.textColor = .white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let placeholder = textView === taskTitleTextView ? "Название" : "Описание"
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}

extension TaskEditionViewController: TaskEditionViewProtocol {
    
    func apply(configuration: Configuration) {
        dateLabel.text = configuration.date
        if configuration.title.isEmpty {
            taskDescriptionTextView.text = "Описание"
            taskDescriptionTextView.textColor = .lightGray
        } else {
            taskDescriptionTextView.text = configuration.description
            taskDescriptionTextView.textColor = .white
        }
        if configuration.description.isEmpty {
            taskTitleTextView.text = "Название"
            taskTitleTextView.textColor = .lightGray
        } else {
            taskTitleTextView.text = configuration.title
            taskTitleTextView.textColor = .white
        }
    }
}

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
