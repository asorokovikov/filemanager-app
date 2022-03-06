import UIKit
import SnapKit

protocol PasswordEditViewInput: AnyObject {
    var model: PasswordEditViewData { get set }
}

protocol PasswordEditViewOutput: AnyObject {
    func savePassword()
    func cancel()
}

// MARK: - PasswordEditViewController

final class PasswordEditViewController: UIViewController, PasswordEditViewInput {

    private let output: PasswordEditViewOutput

    var model: PasswordEditViewData = .initial {
        didSet { view.setNeedsLayout() }
    }

    // MARK: - Subviews

    private lazy var stackView = view.makeVerticalStack()

    private lazy var titleLabel = view.makeTitleLabel(text: "Новый пароль")

    private lazy var subtitleLabel = view.makeSubtitleLabel(text: "Придумайте сложный пароль")

    private lazy var passwordTextField = view.makePasswordField(
        placeholder: "Введите пароль",
        target: self,
        onTextChange: #selector(didChangePasswordText)
    )

    private lazy var confirmPasswordTextField = view.makePasswordField(
        placeholder: "Повторите пароль",
        target: self,
        onTextChange: #selector(didChangeConfirmText)
    )

    private lazy var saveButton = view.makeButton(
        title: "Сохранить",
        target: self,
        selector: #selector(savePassword)
    )

    // MARK: - Lifecycle

    init(output: PasswordEditViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        passwordTextField.text = model.password.text
        confirmPasswordTextField.text = model.confirm.text
        saveButton.isEnabled = model.canSavePassword(model)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = App.Color.background
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancel)).with(tintColor: App.Color.primary)

        setupLayout()
    }

    // MARK: - Private

    @objc private func
    cancel() {
        output.cancel()
    }

    @objc private func
    savePassword() {
        output.savePassword()
    }

    @objc private func
    didChangePasswordText() {
        model.password.onChange(passwordTextField.text ?? .empty)
    }

    @objc private func
    didChangeConfirmText() {
        model.confirm.onChange(confirmPasswordTextField.text ?? .empty)
    }

    private func
    setupLayout() {
        stackView.addArrangedSubviews(titleLabel, subtitleLabel, passwordTextField, confirmPasswordTextField, saveButton)
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        confirmPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }

#if DEBUG
    deinit {
        print("deinit \(self)")
    }
#endif
}
