import UIKit
import PromiseKit

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

    private func configureUI() {
        view.backgroundColor = .systemTeal
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

private enum VCError: Error {

    case weakSelfDeinit
}
