import Foundation

protocol TemperatureFormatter {

    func formatTemperature(_ temperature: Double, locale: Locale) -> String
    func formatFeelsLikeDescription(_ temperature: Double, locale: Locale) -> String
}

struct DefaultTemperatureFormatter: TemperatureFormatter {

    func formatTemperature(_ temperature: Double, locale: Locale) -> String {
        return "\(String(format: "%.1f", temperature)) \(locale.temperatureMeasurementUnit)"
    }

    func formatFeelsLikeDescription(_ temperature: Double, locale: Locale) -> String {
        return "Feels like \(String(format: "%.1f", temperature)) \(locale.temperatureMeasurementUnit)"
    }
}

private extension Locale {

    var temperatureMeasurementUnit: String {
        if usesMetricSystem {
            return "C°"
        } else {
            return "K°"
        }
    }
}
