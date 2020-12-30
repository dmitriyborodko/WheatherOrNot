import Foundation

class Services {

    static let locationService: LocationService = DefaultLocationService()

    static let weatherIconURLFormatter: WeatherIconURLFormatter = DefaultWeatherIconURLFormatter()
    static let windFormatter: WindFormatter = DefaultWindFormatter()
    static let temperatureFormatter: TemperatureFormatter = DefaultTemperatureFormatter()

    static let weatherService: WeatherService = DefaultWeatherService(
        weatherIconURLFormatter: weatherIconURLFormatter,
        windFormatter: windFormatter,
        temperatureFormatter: temperatureFormatter,
        locale: { Locale.current }
    )

    static let imageService: ImageService = DefaultImageService()
}
