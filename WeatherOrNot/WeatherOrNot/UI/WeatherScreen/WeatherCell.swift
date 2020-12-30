import UIKit

class WeatherCell: UITableViewCell, Reusable {

    var temperature: String? {
        get { temperatureLabel.text }
        set { temperatureLabel.text = newValue }
    }

    var icon: UIImage? {
        get { iconImageView.image }
        set { iconImageView.image = newValue }
    }

    var feelsLike: String? {
        get { feelsLikeLabel.text }
        set { feelsLikeLabel.text = newValue }
    }

    var descriptionText: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }

    var windText: String? {
        get { windLabel.text }
        set { windLabel.text = newValue }
    }

    private let overallView: UIView = .init()
    private let temperatureLabel: UILabel = .init()
    private let iconImageView: UIImageView = .init()
    private let feelsLikeLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
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
        overallView.layer.cornerRadius = Constants.overallViewCornerRadius
        overallView.layer.cornerCurve = .continuous
        overallView.backgroundColor = .lightGray
        contentView.addSubview(overallView)
        overallView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.contentEdgeInsets)
            make.left.right.greaterThanOrEqualToSuperview().inset(Constants.contentEdgeInsets)
            make.centerX.equalToSuperview()
        }

        configureTemperatureView()
        configureIconImageView()
        configureFeelsLikeLabel()
        configureDescriptionLabel()
        configureWindLabel()
    }

    func configureTemperatureView() {
        temperatureLabel.font = Constants.temperatureFont
        temperatureLabel.textColor = .darkText
        overallView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(Constants.overallViewInnerInsets)
        }
    }

    func configureIconImageView() {
        overallView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.overallViewInnerInsets)
            make.left.equalTo(temperatureLabel.snp.right).offset(Constants.iconImageViewLeftOffset)
            make.centerY.equalTo(temperatureLabel.snp.centerY)
            make.size.equalTo(Constants.iconImageViewSize)
        }
    }

    func configureFeelsLikeLabel() {
        feelsLikeLabel.font = Constants.secondaryLabelFont
        feelsLikeLabel.textColor = .darkText
        overallView.addSubview(feelsLikeLabel)
        feelsLikeLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(Constants.overallViewInnerInsets)
            make.top.equalTo(temperatureLabel.snp.bottom).offset(Constants.feelsLikeLabelTopOffset)
        }
    }

    func configureDescriptionLabel() {
        descriptionLabel.font = Constants.secondaryLabelFont
        descriptionLabel.textColor = .darkText
        descriptionLabel.numberOfLines = 0
        overallView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(Constants.overallViewInnerInsets)
            make.top.equalTo(feelsLikeLabel.snp.bottom)
        }
    }

    func configureWindLabel() {
        windLabel.font = Constants.secondaryLabelFont
        windLabel.textColor = .darkText
        overallView.addSubview(windLabel)
        windLabel.snp.makeConstraints { make in
            make.right.bottom.left.equalToSuperview().inset(Constants.overallViewInnerInsets)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.windLabelTopOffset)
        }
    }
}

private enum Constants {

    static let contentEdgeInsets: UIEdgeInsets = .init(top: 32.0, left: 16.0, bottom: 32.0, right: 16.0)

    static let overallViewCornerRadius: CGFloat = 32.0
    static let overallViewInnerInsets: UIEdgeInsets = .init(top: 16.0, left: 32.0, bottom: 16.0, right: 32.0)

    static let iconImageViewSize: CGSize = .init(width: 66.0, height: 66.0)
    static let iconImageViewLeftOffset: CGFloat = 8.0

    static let temperatureFont: UIFont = UIFont.systemFont(ofSize: 50.0, weight: .thin)
    static let secondaryLabelFont: UIFont = UIFont.systemFont(ofSize: 18.0, weight: .thin)

    static let feelsLikeLabelTopOffset: CGFloat = 8.0

    static let windLabelTopOffset: CGFloat = 16.0
}
