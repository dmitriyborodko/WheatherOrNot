import Foundation

struct Weather {

    /// Let s make them all optionals, because we can't affect this third party API.

    let mainDescription: String?
    let detailedDescription: String?
    let iconName: String?
    let temperature: Double?
    let feelsLike: Double?
    let windSpeed: Double?
    let windDirection: Double?
}

extension Weather: Decodable {

    private enum ResponseCodingKeys: String, CodingKey {
        case weather
        case main
        case wind
    }

    private enum WeatherCodingKeys: String, CodingKey {
        case main
        case description
        case iconName = "icon"
    }

    private enum MainCodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
    }

    private enum WindCodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseCodingKeys.self)

        let weatherContainer = try container.nestedContainer(keyedBy: WeatherCodingKeys.self, forKey: .weather)
        self.mainDescription = try? weatherContainer.decode(String.self, forKey: .main)
        self.detailedDescription = try? weatherContainer.decode(String.self, forKey: .description)
        self.iconName = try? weatherContainer.decode(String.self, forKey: .iconName)

        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        self.temperature = try? mainContainer.decode(Double.self, forKey: .temperature)
        self.feelsLike = try? mainContainer.decode(Double.self, forKey: .feelsLike)

        let windContainer = try container.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)
        self.windSpeed = try? windContainer.decode(Double.self, forKey: .speed)
        self.windDirection = try? windContainer.decode(Double.self, forKey: .degree)
    }
}
