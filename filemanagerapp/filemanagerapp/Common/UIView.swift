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

        textField.addTarget(target, action: onTextChange, for: .editingChanged)
        return textField
    }

    func makePasswordField(placeholder: String = "????????????" ,target: Any, onTextChange: Selector) -> UITextField {
        let textField = makeTextField(target: target, onTextChange: onTextChange)
        textField.setImage(App.Images.lockFill)
        textField.placeholder = placeholder
        textField.isSecureTextEntry = true
        return textField
    }

    func makeLabel(text: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = font
        return label
    }

    func makeTitleLabel(text: String) -> UILabel {
        let font = UIFont.preferredFont(forTextStyle: .title1).bold()
        return makeLabel(text: text, font: font)
    }

    func makeSubtitleLabel(text: String) -> UILabel {
        let font = UIFont.preferredFont(forTextStyle: .title3)
        let label =  makeLabel(text: text, font: font)
        label.textColor = App.Color.secondaryText
        return label
    }

    func makeErrorLabel(text: String? = nil) -> UILabel {
        let label = makeLabel(text: text ?? .empty, font: .preferredFont(forTextStyle: .subheadline))
        label.textColor = App.Color.failure
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }

    func makeVerticalStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
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
