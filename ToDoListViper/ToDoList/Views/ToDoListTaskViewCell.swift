//
//  ToDoListTaskViewCell.swift
//  ToDoListViper
//
//  Created by Mariya Slepneva on 15.08.2025.
//

import UIKit

final class ToDoListTaskViewCell: UITableViewCell, Configurable {

    // MARK: - Nested Types

    struct Configuration {
        
        let title: String
        let description: String
        let isCompleted: Bool
        let creationDate: String
        let onTapGesture: () -> Void
    }

    // MARK: - Type Properties

    static let identifier: String = String(describing: ToDoListTaskViewCell.self)

    // MARK: - Private Properties

    private let container = UIStackView()
    private let completionButton = UIButton()
    private let taskInfoContainer = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()

    private var configuration: Configuration?

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configireView()
        configureContainer()
        configureTaskInfoContainer()
        configureCompletionButton()
        configureDateLabel()
        configureTitleLabel()
        configureDescriptionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        resetUI()
    }
    
    // MARK: - Internal Methods

    func apply(configuration: Configuration) {
        self.configuration = configuration
        setupCompletionButtonStyle()
        setupTextsStyles()
    }

    // MARK: - Private Methods
    
    private func configireView() {
        contentView.addSubview(container)
        selectionStyle = .none
    }

    private func configureContainer() {
        container.spacing = Constants.contentSpacing
        container.axis = .horizontal
        container.alignment = .top
        container.distribution = .fill

        container.addArrangedSubview(completionButton)
        container.addArrangedSubview(taskInfoContainer)

        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.contentInsets.top),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.contentInsets.bottom),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInsets.left),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.contentInsets.right)
        ])
    }

    private func configureCompletionButton() {
        completionButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        completionButton.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: Constants.completionButtonPointSize),
            forImageIn: .normal
        )
    }

    private func configureTaskInfoContainer() {
        taskInfoContainer.axis = .vertical
        taskInfoContainer.spacing = Constants.taskInfoSpacing
        taskInfoContainer.alignment = .leading
        taskInfoContainer.distribution = .fillProportionally
        taskInfoContainer.addArrangedSubview(titleLabel)
        taskInfoContainer.addArrangedSubview(descriptionLabel)
        taskInfoContainer.addArrangedSubview(dateLabel)
    }

    private func configureDateLabel() {
        dateLabel.textColor = UIColor.secondaryTextColor
        dateLabel.font = .systemFont(ofSize: Constants.dateLabelFontSize, weight: .medium)
    }

    private func configureTitleLabel() {
        titleLabel.numberOfLines = Constants.titleLabelNumberOfLines
        titleLabel.font = .systemFont(ofSize: Constants.titleLabelFontSize)
    }

    private func configureDescriptionLabel() {
        descriptionLabel.numberOfLines = Constants.descriptionLabelNumberOfLines
        descriptionLabel.font = .systemFont(ofSize: Constants.descriptionLabelFontSize)
    }

    private func setupCompletionButtonStyle() {
        guard let configuration else { return }
        let imageName = configuration.isCompleted ? Constants.completedTaskButtonImage : Constants.defaultButtonImage
        let color: UIColor = configuration.isCompleted ? .accent : .gray
        completionButton.setImage(UIImage(systemName: imageName), for: .normal)
        completionButton.tintColor = color
    }

    private func setupTextsStyles() {
        guard let configuration else { return }
        dateLabel.text = configuration.creationDate
        descriptionLabel.text = configuration.description
        descriptionLabel.textColor = configuration.isCompleted ? .secondaryTextColor : .white
        titleLabel.attributedText = configuration.isCompleted
            ? NSAttributedString.makeStrikethroughText(configuration.title)
            : NSAttributedString(string: configuration.title)
        titleLabel.textColor = configuration.isCompleted ? .secondaryTextColor : .white
        [dateLabel, descriptionLabel, titleLabel].forEach {
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }
    
    private func resetUI() {
        descriptionLabel.textColor = .white
        titleLabel.textColor = .white
        titleLabel.attributedText = nil
        configuration = nil
    }

    @objc private func pressed() {
        configuration?.onTapGesture()
    }
}

// MARK: - Constants

private enum Constants {

    static let contentSpacing: CGFloat = 8.0
    static let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 12.0, left: 20.0, bottom: -12.0, right: -20.0)
    static let taskInfoSpacing: CGFloat = 6.0
    static let dateLabelFontSize: CGFloat = 12.0
    static let titleLabelFontSize: CGFloat = 16.0
    static let titleLabelNumberOfLines: Int = 1
    static let descriptionLabelNumberOfLines: Int = 2
    static let descriptionLabelFontSize: CGFloat = 12.0
    static let completionButtonPointSize: CGFloat = 24.0
    static let defaultButtonImage: String = "circle"
    static let completedTaskButtonImage: String = "checkmark.circle"
}
