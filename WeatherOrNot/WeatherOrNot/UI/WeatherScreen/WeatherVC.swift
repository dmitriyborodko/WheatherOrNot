import UIKit
import PromiseKit
import SnapKit

class WeatherVC: UIViewController {

    private enum State {
        case loading
        case presenting(Weather)
        case error(Error)
    }

    private lazy var tableView: UITableView = makeTableView()

    private var state: State = .loading

    private let locationService: LocationService
    private let weatherService: WeatherService
    private let imageService: ImageService

    init(
        locationService: LocationService = Services.locationService,
        weatherService: WeatherService = Services.weatherService,
        imageService: ImageService = Services.imageService
    ) {
        self.locationService = locationService
        self.weatherService = weatherService
        self.imageService = imageService

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

    @objc private func onRefreshControlValueChange() {
        loadData()
    }

    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefreshControlValueChange), for: .valueChanged)
        tableView.refreshControl = refreshControl

        return tableView
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        tableView.backgroundColor = nil
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(additionalSafeAreaInsets)
        }
    }

    private func reloadTableView() {
        switch self.state {
        case .loading:
            self.tableView.refreshControl?.beginRefreshing()

        case .presenting, .error:
            self.tableView.refreshControl?.endRefreshing()
        }

        self.tableView.reloadData()
    }

    private func loadData() {
        self.state = .loading
        self.reloadTableView()

        firstly {
            locationService.authorize()
        }.then { [weak self] _ -> Promise<Location> in
            guard let self = self else { throw VCError.weakSelfDeinit }

            return self.locationService.fetchLocation()
        }.then { [weak self] location -> Promise<Weather> in
            guard let self = self else { throw VCError.weakSelfDeinit }

            return self.weatherService.fetchWeather(with: location)
        }.done { [weak self] weather in
            guard let self = self else { return }

            self.state = .presenting(weather)
            self.reloadTableView()
        }.catch { [weak self] error in
            guard let self = self else { return }

            self.state = .error(error)
            self.reloadTableView()
        }
    }
}

extension WeatherVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .loading:
            return 0

        case .presenting:
            return 1

        case .error:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .loading:
            return UITableViewCell()

        case .presenting(let weather):
            return dequeueWeatherCell(in: tableView, with: weather)

        case .error(let error):
            let cell: ErrorCell = tableView.registerAndDequeueReusableCell()
            cell.title = "\(error.localizedDescription)"

            return cell
        }
    }

    private func dequeueWeatherCell(in tableView: UITableView, with weather: Weather) -> UITableViewCell {
        let cell: WeatherCell = tableView.registerAndDequeueReusableCell()
        cell.temperature = weather.temperature
        cell.feelsLike = weather.feelsLike
        cell.descriptionText = weather.description
        cell.windText = weather.wind

        cell.icon = #imageLiteral(resourceName: "camera")
        if let iconURL = weather.iconURL {
            firstly {
                imageService.fetchImage(with: iconURL)
            }.done { [weak cell] image in
                cell?.icon = image
            }.cauterize()
        }

        return cell
    }
}

private enum VCError: Error {

    case weakSelfDeinit
}
