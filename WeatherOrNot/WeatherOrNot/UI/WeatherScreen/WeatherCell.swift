import UIKit

class WeatherCell: UITableViewCell, Reusable {

    var temperature: String? {
        get { temperatureLabel.text }
        set { temperatureLabel.text = newValue }
    }

    private let overallView: UIView = .init()
    private let temperatureLabel: UILabel = .init()
    private let iconImageView: UIImageView = .init()
    private let descriptionLabel: UILabel = .init()
    private let feelsLikeLabel: UILabel = .init()
    private let windLabel: UILabel = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        configureOverallView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureOverallView() {
        addSubview(overallView)
        overallView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        configureTemperatureView()
        configureIconImageView()
    }

    func configureTemperatureView() {
        temperatureLabel.text = "-10"
        overallView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
    }

    func configureIconImageView() {
        overallView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(temperatureLabel.snp.left).offset(Constants.iconImageViewLeftOffset)
        }
    }
}

private enum Constants {

    static let iconImageViewSize: CGSize = .init(width: 50.0, height: 50.0)
    static let iconImageViewLeftOffset: CGFloat = 8.0
}
