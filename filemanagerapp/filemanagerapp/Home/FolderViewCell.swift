import UIKit
import SnapKit

final class FolderViewCell: UITableViewCell {

    var title: String {
        get { titleLabel.text ?? .empty }
        set { titleLabel.text = newValue }
    }

    var image: UIImage? {
        get { contentImageView.image }
        set { contentImageView.image = newValue }
    }

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func
    setupSubviews() {
        
        contentView.addSubviews(titleLabel, contentImageView)
        contentImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
            make.width.equalTo(contentView).dividedBy(5)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.75)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentImageView.snp.trailing)
            make.trailing.equalTo(contentView).offset(-8)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
}
