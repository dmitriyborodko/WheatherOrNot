import Foundation

protocol WeatherIconURLFormatter {

    func format(_ string: String) -> URL?
}

struct DefaultWeatherIconURLFormatter: WeatherIconURLFormatter {

    func format(_ iconName: String) -> URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png")
    }
}
