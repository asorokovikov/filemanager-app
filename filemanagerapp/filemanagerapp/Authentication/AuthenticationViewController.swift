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

    private let errorView = ErrorMessageView()

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

        button.title = model.button.text
        button.isEnabled = model.button.enabled
        textField.text = model.password.text
        errorView.errorText = model.error
    }

    override func viewDidLoad() {
        view.backgroundColor = App.Color.background
        setupLayout()
    }

    // MARK: - Private methods

    @objc private func
    didChangeText() {
        model.password.onChange(textField.text ?? .empty)
    }

    @objc private func
    didTapButton() {
        output.login()
    }

    private func
    setupLayout() {
        let imageView = UIImageView(image: App.Images.personFill)
        imageView.tintColor = App.Color.inactiveText

        view.addSubviews(imageView, errorView)

        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).dividedBy(2)
            make.centerX.equalTo(view)
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.height.equalTo(view.snp.width).dividedBy(2)
        }
        errorView.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.centerY.equalTo(view)
            make.height.equalTo(50)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(errorView.snp.bottom).offset(16)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.height.equalTo(50)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.height.equalTo(50)
        }
    }
}
