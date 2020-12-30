import Foundation

class Services {

    static let locationService: LocationService = DefaultLocationService()

    static let weatherIconURLFormatter: WeatherIconURLFormatter = DefaultWeatherIconURLFormatter()
    static let windDirectionFormatter: WindDirectionFormatter = DefaultWindDirectionFormatter()

    static let weatherService: WeatherService = DefaultWeatherService(
        weatherIconURLFormatter: weatherIconURLFormatter,
        windDirectionFormatter: windDirectionFormatter
    )
}
