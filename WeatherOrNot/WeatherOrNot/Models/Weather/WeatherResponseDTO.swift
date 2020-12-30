import Foundation

struct WeatherResponseDTO: Decodable {

    let weather: [WeatherDTO]?
    let main: WeatherMainDTO?
    let wind: WeatherWindDTO?
}

struct WeatherDTO: Decodable {

    let description: String?
    let icon: String?
}

struct WeatherMainDTO: Decodable {

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }

    let temp: Double?
    let feelsLike: Double?
}

struct WeatherWindDTO: Decodable {

    enum CodingKeys: String, CodingKey {
        case speed
        case deg
    }

    let speed: Double?
    let deg: Double?
}
