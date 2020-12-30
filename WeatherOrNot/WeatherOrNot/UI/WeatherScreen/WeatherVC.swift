import UIKit
import PromiseKit
import SnapKit

class WeatherVC: UIViewController {

    private lazy var weatherOverallView: WeatherOverallView = .init()

    private let locationService: LocationService
    private let weatherService: WeatherService

    init(
        locationService: LocationService = Services.locationService,
        weatherService: WeatherService = Services.weatherService
    ) {
        self.locationService = locationService
        self.weatherService = weatherService

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = UIView()

        configureUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    private func configureUI() {
        view.backgroundColor = .systemTeal
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(weatherOverallView)
        weatherOverallView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(Constants.contentEdgeInsets)
        }
    }

    private func loadData() {
        firstly {
            locationService.authorize()
        }.then { [weak self] _ -> Promise<Location> in
            guard let self = self else { throw VCError.weakSelfDeinit }

            return self.locationService.fetchLocation()
        }.then { [weak self] location -> Promise<Weather> in
            guard let self = self else { throw VCError.weakSelfDeinit }

            return self.weatherService.fetchWeather(with: location)
        }.done { [weak self] weather in
            print(weather)
        }.catch { error in
            print(error)
        }
    }
}

private enum VCError: Error {

    case weakSelfDeinit
}

private enum Constants {

    static let contentEdgeInsets: UIEdgeInsets = .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
}
