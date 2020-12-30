import UIKit

class ErrorCell: UITableViewCell, Reusable {

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    private lazy var titleLabel: UILabel = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(32.0)
            make.centerX.equalToSuperview()
        }
    }
}
