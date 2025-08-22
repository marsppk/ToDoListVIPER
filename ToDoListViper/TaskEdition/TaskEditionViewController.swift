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
        setupView()
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
    
    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
    }
    
    private func setupScrollView() {
        scrollView.addSubview(container)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.scrollViewHorizontalInset
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.scrollViewHorizontalInset
            ),
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
        dateLabel.font = .systemFont(ofSize: Constants.dateFontSize)
        dateLabel.textColor = UIColor.secondaryTextColor
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(
                equalTo: taskTitleTextView.bottomAnchor,
                constant: Constants.spacingBetweenTitleAndDate
            ),
            dateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            dateLabel.bottomAnchor.constraint(
                equalTo: taskDescriptionTextView.topAnchor,
                constant: -Constants.spacingBetweenDateAndDescription
            )
        ])
    }

    private func setupTaskTitleTextView() {
        taskTitleTextView.font = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        taskTitleTextView.delegate = self
        taskTitleTextView.returnKeyType = .done
        taskTitleTextView.isScrollEnabled = false
        taskTitleTextView.textContainer.lineFragmentPadding = .zero

        taskTitleTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskTitleTextView.topAnchor.constraint(equalTo: container.topAnchor),
            taskTitleTextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            taskTitleTextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            taskTitleTextView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: Constants.titleTextViewMinHeight
            )
        ])
    }
    
    private func setupTaskDescriptionTextView() {
        taskDescriptionTextView.font = .systemFont(ofSize: Constants.descriptionFontSize, weight: .regular)
        taskDescriptionTextView.delegate = self
        taskDescriptionTextView.returnKeyType = .done
        taskDescriptionTextView.isScrollEnabled = false
        taskDescriptionTextView.textContainer.lineFragmentPadding = .zero

        taskDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskDescriptionTextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            taskDescriptionTextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            taskDescriptionTextView.bottomAnchor.constraint(
                equalTo: container.bottomAnchor,
                constant: -Constants.descriptionBottomInset
            )
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
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom + Constants.descriptionBottomInset
        let contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardHeight, right: .zero)
        
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
        let placeholder = textView === taskTitleTextView
            ? Constants.titleTextViewPlaceholder
            : Constants.descriptionTextViewPlaceholder
        if textView.text == placeholder && textView.isFirstResponder {
            textView.text = ""
            textView.textColor = .white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let placeholder = textView === taskTitleTextView
            ? Constants.titleTextViewPlaceholder
            : Constants.descriptionTextViewPlaceholder
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}

extension TaskEditionViewController: TaskEditionViewProtocol {
    
    func apply(configuration: Configuration) {
        dateLabel.text = configuration.date
        taskDescriptionTextView.text = configuration.title.isEmpty
            ? Constants.descriptionTextViewPlaceholder
            : configuration.description
        taskDescriptionTextView.textColor = configuration.title.isEmpty ? .lightGray : .white
        taskTitleTextView.text = configuration.description.isEmpty
            ? Constants.titleTextViewPlaceholder
            : configuration.title
        taskTitleTextView.textColor = configuration.description.isEmpty ? .lightGray : .white
    }
}

private enum Constants {
    
    static let titleTextViewPlaceholder = "Название"
    static let descriptionTextViewPlaceholder = "Описание"
    static let scrollViewHorizontalInset: CGFloat = 20
    static let titleTextViewMinHeight: CGFloat = 42
    static let spacingBetweenTitleAndDate: CGFloat = 8
    static let spacingBetweenDateAndDescription: CGFloat = 8
    static let descriptionBottomInset: CGFloat = 8
    static let keyboardAnimationDuration: TimeInterval = 0.3
    static let titleFontSize: CGFloat = 34
    static let dateFontSize: CGFloat = 12
    static let descriptionFontSize: CGFloat = 16
}
