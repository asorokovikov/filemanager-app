import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }

    func setCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    func makeButton(title: String = .empty, target: Any, selector: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setCorner(radius: 8)
        // normal
        button.setTitleColor(App.Color.background, for: .normal)
        button.setBackgroundImage(App.Color.primary.image, for: .normal)
        // highlighted
        button.setTitleColor(App.Color.background.highlighted, for: .highlighted)
        button.setBackgroundImage(App.Color.primary.image, for: .highlighted)
        //disabled
        button.setTitleColor(App.Color.inactiveText, for: .disabled)
        button.setBackgroundImage(App.Color.secondaryBackground.image, for: .disabled)

        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: selector, for: .touchUpInside)
        return button
    }

    func makeTextField(target: Any, onTextChange: Selector) -> UITextField {
        let textField = UITextField()
        textField.textColor = App.Color.text
        textField.autocapitalizationType = .none
        textField.backgroundColor = App.Color.secondaryBackground
        textField.tintColor = App.Color.primary
        textField.clearButtonMode = .always

        textField.setCorner(radius: 8)
        textField.setBorder(width: 0.5, color: App.Color.secondaryBackground)

        // TODO: Add right padding
        if let clearButton = textField.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(App.Images.xmark, for: .normal)
            clearButton.tintColor = App.Color.inactiveText
        }

        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(target, action: onTextChange, for: .editingChanged)
        return textField
    }

    func makePasswordField(target: Any, onTextChange: Selector) -> UITextField {
        let textField = makeTextField(target: target, onTextChange: onTextChange)
        textField.setImage(App.Images.lockFill)
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        return textField
    }

    func makeErrorLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.backgroundColor = App.Color.failure.withAlphaComponent(0.1)
        label.setBorder(width: 0.5, color: App.Color.failure)
        label.setCorner(radius: 8)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = App.Color.failure
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }

    func fadeIn() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }

    func fadeOut() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
