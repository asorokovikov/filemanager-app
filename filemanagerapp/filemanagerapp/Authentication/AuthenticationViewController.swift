import UIKit
import SnapKit

protocol AuthenticationViewInput: AnyObject {
    var model: AuthenticationViewData { get set }
}

protocol AuthenticationViewOutput: AnyObject {
    func login()
}

// MARK: - AuthenticationViewController

final class AuthenticationViewController: UIViewController, AuthenticationViewInput {

    var model: AuthenticationViewData = .initial {
        didSet { view.setNeedsLayout() }
    }

    // MARK: - Private

    private let output: AuthenticationViewOutput
    private let contentView = UIView()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: App.Images.person)
        imageView.tintColor = App.Color.inactiveText
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var button = view.makeButton(
        target: self,
        selector: #selector(didTapButton)
    )

    private lazy var textField = view.makePasswordField(
        target: self,
        onTextChange: #selector(didChangeText)
    )

    // MARK: - Lifecycle

    init(output: AuthenticationViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        switch model {
        case .newPassword(let password, let confirmPassword, let isConfirmationPhase, let canSavePassword):
            if isConfirmationPhase {
                button.title = "Повторите пароль"
                button.isEnabled = canSavePassword(confirmPassword.text)
                textField.text = confirmPassword.text
            } else {
                button.title = "Создать пароль"
                button.isEnabled = canSavePassword(password.text)
                textField.text = password.text
            }
        case .authentication(let password, let canSavePassword):
            button.title = "Введите пароль"
            button.isEnabled = canSavePassword(password.text)
            textField.text = password.text
        }
    }

    override func viewDidLoad() {
        view.backgroundColor = App.Color.background
        textField.delegate = self
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotification()
    }

    // MARK: - Private

    @objc private func
    didChangeText() {
        let passwordText = textField.text ?? String.empty
        switch model {
        case .newPassword(let password, let confirmPassword, let isConfirmationPhase, _):
            if isConfirmationPhase {
                confirmPassword.onChange(passwordText)
            } else {
                password.onChange(passwordText)
            }
        case .authentication(let password, _):
            password.onChange(passwordText)
        }
    }

    @objc private func
    didTapButton() {
        output.login()
    }

    private func
    setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(imageView, textField, button)

        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-16)
            make.height.equalTo(view).dividedBy(2).offset(16)
        }
        textField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}

// MARK: - Keyboard Handler

extension AuthenticationViewController {
    private func
    registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func
    unregisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func
    onKeyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func
    onKeyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

// MARK: - UITextFieldDelegate

extension AuthenticationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
