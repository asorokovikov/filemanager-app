import UIKit

final class ErrorMessageView: UIView {

    var onClose: Action?

    var errorText: String? {
        get { label.text }
        set { setErrorIfChanged(newValue) }
    }

    // MARK: - Subviews
    
    private let label = UILabel()

    private let closeButton = UIButton()

    // MARK: Overriden

    init(errorText: String? = nil, onClose: Action? = nil) {
        super.init(frame: .zero)
        self.onClose = onClose
        self.errorText = errorText
        setupLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: Private

    private func
    setErrorIfChanged(_ errorText: String?) {
        guard errorText != label.text else {
            return
        }
        label.text = errorText
        alpha = errorText != nil ? 1.0 : 0.0
    }


    @objc private func
    buttonTap() {
        onClose?()
    }

    private func
    setupLayout() {
        alpha = 0
        backgroundColor = App.Color.failure.withAlphaComponent(0.15)
        setBorder(width: 0.5, color: App.Color.failure)
        setCorner(radius: 8)

        closeButton.tintColor = App.Color.failure
        closeButton.setImage(App.Images.xmark, for: .normal)
        closeButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        closeButton.isHidden = onClose == nil
        closeButton.isEnabled = onClose != nil

        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = App.Color.failure

        addSubviews(label, closeButton)

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(4)
            make.trailing.equalTo(self).offset(-4)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        label.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(16)
            make.top.equalTo(self).offset(16)
            make.trailing.equalTo(closeButton.snp.leading).offset(-16)
            make.bottom.equalTo(self).offset(-16)
        }
    }
}
