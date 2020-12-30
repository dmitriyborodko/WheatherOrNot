import Foundation

struct Weather {

    /// Let s make them all optionals, because we can't affect this third party API.

    let description: String?
    let iconURL: URL?
    let temperature: String?
    let feelsLike: String?
    let wind: String?
}

extension Weather {

    init(
        withDTO dto: WeatherResponseDTO,
        iconURLFormatter: WeatherIconURLFormatter,
        windFormatter: WindFormatter,
        temperatureFormatter: TemperatureFormatter,
        locale: Locale
    ) {
        self.description = dto.weather?.first?.description
        self.iconURL = dto.weather?.first?.icon.flatMap(iconURLFormatter.format)
        self.temperature = dto.main?.temp.flatMap { temperatureFormatter.formatTemperature($0, locale: locale) }
        self.feelsLike = dto.main?.feelsLike.flatMap { temperatureFormatter.formatTemperature($0, locale: locale) }

        if let windSpeed = dto.wind?.speed, let windDegree = dto.wind?.speed {
            self.wind = windFormatter.format(speed: windSpeed, degree: windDegree)
        } else {
            self.wind = nil
        }
    }
}
