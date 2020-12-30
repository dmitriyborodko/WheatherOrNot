import Foundation

struct Weather {

    /// Let s make them all optionals, because we can't affect this third party API.

    let overview: String?
    let description: String?
    let iconURL: URL?
    let temperature: Double?
    let feelsLike: Double?
    let windSpeed: Double?
    let windDirection: String?
}

extension Weather {

    init(
        withDTO dto: WeatherResponseDTO,
        iconURLFormatter: WeatherIconURLFormatter,
        windDirectionFormatter: WindDirectionFormatter
    ) {
        self.overview = dto.weather?.first?.main
        self.description = dto.weather?.first?.description
        self.iconURL = dto.weather?.first?.icon.flatMap(iconURLFormatter.format)
        self.temperature = dto.main?.temp
        self.feelsLike = dto.main?.feelsLike
        self.windSpeed = dto.wind?.speed
        self.windDirection = dto.wind?.deg.flatMap(windDirectionFormatter.format)
    }
}
