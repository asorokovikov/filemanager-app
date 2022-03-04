import UIKit

final class AuthenticationView: UIView {
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.tintColor = UIColor(rgba: "4885CC")
        textField.autocapitalizationType = .none
        textField.backgroundColor = App.Color.secondaryBackground
        textField.setImage(App.Images.lockFill)
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.setCorner(radius: 10)
        textField.setBorder(width: 0.5, color: .lightGray)
        return textField
    }()

    let button: UIButton = {
        let button = UIButton(title: "Создать пароль", titleColor: .white)
        button.setBackgroundImage(App.Color.primary.image, for: .normal)
        button.setBackgroundImage(App.Color.primary.highlighted.image, for: .highlighted)
        button.setCorner(radius: 10)
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: App.Images.personFill)
        imageView.tintColor = App.Color.secondaryBackground
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func
    setupLayout() {
        backgroundColor = App.Color.background
        addSubviews(imageView, passwordTextField, button)

        let view = self
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(view).offset(-100)
            make.centerX.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(50)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.height.equalTo(50)
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.height.equalTo(50)
        }
    }
}
