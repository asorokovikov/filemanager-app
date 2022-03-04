import UIKit

struct SwitchTableRow: TableRow {
    let title: String
    let value: Bool
    let action: TableAction? = nil
    let onChange: (Bool) -> Void

    func configureCell(_ cell: UITableViewCell) -> UITableViewCell {
        guard let cell = cell as? SwitchTableViewCell else {
            assertionFailure("Failed to cast \(cell.self) to SwitchTableViewCell")
            return cell
        }
        cell.textLabel?.text = title
        cell.textLabel?.numberOfLines = 2
        cell.selectionStyle = .none
        cell.isOn = value
        cell.onChange = onChange

        return AppStyleGuide.configureTableViewCell(cell)
    }

    static let cell = TableCell(type: SwitchTableViewCell.self)
}

final class SwitchTableViewCell: UITableViewCell {

    // MARK: - Public

    var onChange: ((Bool) -> Void)?

    var text: String {
        get { textLabel?.text ?? .empty }
        set { textLabel?.text = newValue }
    }

    var isOn: Bool {
        get { flipSwitch.isOn }
        set { flipSwitch.isOn = newValue }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    convenience init() {
        self.init(style: .default, reuseIdentifier: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Private

    private let flipSwitch = UISwitch()

    private func setupSubviews() {
        selectionStyle = .none

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapRow)
        )
        contentView.addGestureRecognizer(tapGestureRecognizer)

        flipSwitch.addTarget(self, action: #selector(didChangeSwitch), for: .valueChanged)
        accessoryView = flipSwitch

        AppStyleGuide.configureTableViewCell(self)
    }

    @objc private func didChangeSwitch(_ flipSwitch: UISwitch) {
        onChange?(flipSwitch.isOn)
    }

    @objc private func didTapRow() {
        flipSwitch.setOn(!isOn, animated: true)
        didChangeSwitch(flipSwitch)
    }
}
