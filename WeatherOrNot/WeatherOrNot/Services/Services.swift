import Foundation

class Services {

    static let locationService: LocationService = DefaultLocationService()
    static let weatherService: WeatherService = DefaultWeatherService()
}
