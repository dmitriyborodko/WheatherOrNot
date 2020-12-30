import Foundation

protocol WindFormatter {

    func format(speed: Double, degree: Double) -> String
}

struct DefaultWindFormatter: WindFormatter {

    func format(speed: Double, degree: Double) -> String {
        return "Wind: \(String(format: "%.1f", speed)) m/s, \(Direction(degree).rawValue)"
    }
}

private enum Direction: String, CaseIterable, CustomStringConvertible {

    case N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW

    var description: String { rawValue.uppercased() }

    init<D: BinaryFloatingPoint>(_ direction: D) {
        self = Self.allCases[Int((direction.angle + 11.25).truncatingRemainder(dividingBy: 360) / 22.5)]
    }
}


private extension BinaryFloatingPoint {

    var angle: Self {
        (truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
    }
    var direction: Direction { .init(self) }
}
