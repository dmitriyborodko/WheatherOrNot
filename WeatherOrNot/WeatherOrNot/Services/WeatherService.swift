import Foundation
import PromiseKit

protocol WeatherService {

    func fetchWeather(with locaiton: Location) -> Promise<Weather>
}

class DefaultWeatherService: WeatherService {

    let weatherIconURLFormatter: WeatherIconURLFormatter
    let windDirectionFormatter: WindDirectionFormatter

    init(weatherIconURLFormatter: WeatherIconURLFormatter, windDirectionFormatter: WindDirectionFormatter) {
        self.weatherIconURLFormatter = weatherIconURLFormatter
        self.windDirectionFormatter = windDirectionFormatter
    }

    func fetchWeather(with location: Location) -> Promise<Weather> {
        var urlComponents = Constants.weatherURLConponents
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(location.latitude)"),
            URLQueryItem(name: "lon", value: "\(location.longitude)"),
            URLQueryItem(name: "appid", value: Constants.appKey),
            URLQueryItem(name: "units", value: Locale.current.measurementSystem.rawValue)
        ]

        guard let url = urlComponents.url else { return Promise(error: WeatherServiceError.unknown) }

        return firstly {
            URLSession.shared.dataTask(.promise, with: URLRequest(url: url))
        }.map { data, _ in
            try JSONDecoder().decode(WeatherResponseDTO.self, from: data)
        }.map { [weak self] dto in
            guard let self = self else { throw WeatherServiceError.unknown }

            return Weather(
                withDTO: dto,
                iconURLFormatter: self.weatherIconURLFormatter,
                windDirectionFormatter: self.windDirectionFormatter
            )
        }
    }
}

enum WeatherServiceError: Error {
    case unknown
}

private enum Constants {

    static let weatherURLConponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
    static let appKey: String = "2ffedf5f3cc7cea9cbcc23dcefed4782"
    static let timeoutInterval: TimeInterval = 10.0
}

private extension Locale {

    enum MeasurementSystemType: String {
        case imperial = "imperial"
        case metric = "metric"
    }

    var measurementSystem : MeasurementSystemType {
        return usesMetricSystem ? .metric : .imperial
    }
}
