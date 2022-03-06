import UIKit

public struct ToastConfiguration {
    public let autoHide: Bool
    public let displayTime: TimeInterval
    public let animationTime: TimeInterval

    public let view: UIView?

    public init(
        autoHide: Bool = true,
        displayTime: TimeInterval = 3,
        animationTime: TimeInterval = 0.2,
        attachTo view: UIView? = nil
    ) {
        self.autoHide = autoHide
        self.displayTime = displayTime
        self.animationTime = animationTime
        self.view = view
    }
}

public protocol ToastView : UIView {
    func createView(for toast: Toast)
}

public class TextToastView : UIStackView {
    public init(_ title: String, subtitle: String? = nil) {
        super.init(frame: CGRect.zero)
        axis = .vertical
        alignment = .center
        distribution = .fillEqually

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.numberOfLines = 1
        addArrangedSubview(titleLabel)

        if let subtitle = subtitle {
            let subtitleLabel = UILabel()
            subtitleLabel.textColor = .systemGray
            subtitleLabel.text = subtitle
            subtitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
            addArrangedSubview(subtitleLabel)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class AppleToastView : UIView, ToastView {
    private let minHeight: CGFloat
    private let minWidth: CGFloat

    private let darkBackgroundColor: UIColor
    private let lightBackgroundColor: UIColor

    private let child: UIView

    private var toast: Toast?

    public init(
        child: UIView,
        minHeight: CGFloat = 58,
        minWidth: CGFloat = 150,
        darkBackgroundColor: UIColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00),
        lightBackgroundColor: UIColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    ) {
        self.minHeight = minHeight
        self.minWidth = minWidth
        self.darkBackgroundColor = darkBackgroundColor
        self.lightBackgroundColor = lightBackgroundColor
        self.child = child
        super.init(frame: .zero)

        addSubview(child)
    }

    public func createView(for toast: Toast) {
        self.toast = toast
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight),
            widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth),
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 10),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: -10),
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor, constant: 0),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])

        addSubviewConstraints()
        style()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.animate(withDuration: 0.5) {
            self.style()
        }
    }

    private func style() {
        layoutIfNeeded()
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2
        if #available(iOS 12.0, *) {
            backgroundColor = traitCollection.userInterfaceStyle == .light ? lightBackgroundColor : darkBackgroundColor
        } else {
            backgroundColor = lightBackgroundColor
        }

        addShadow()
    }

    private func addSubviewConstraints() {
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            child.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            child.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            child.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ])
    }

    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.22).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }

    required init?(coder: NSCoder) {
        nil
    }
}

public class IconAppleToastView : UIStackView {
    public static var defaultImageTint: UIColor {
        return .label
    }

    public init(image: UIImage, imageTint: UIColor? = defaultImageTint, title: String, subtitle: String? = nil) {
        super.init(frame: CGRect.zero)
        axis = .horizontal
        spacing = 15
        alignment = .center
        distribution = .fill

        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 2
        vStack.alignment = .center

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.numberOfLines = 1
        vStack.addArrangedSubview(titleLabel)

        if let subtitle = subtitle {
            let subtitleLabel = UILabel()
            subtitleLabel.textColor = .systemGray
            subtitleLabel.text = subtitle
            subtitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
            vStack.addArrangedSubview(subtitleLabel)
        }

        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = imageTint
        imageView.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28)
        ])

        addArrangedSubview(imageView)
        addArrangedSubview(vStack)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
