import CoreLocation

struct Location {

    let latitude: Double
    let longitude: Double
}

extension Location {

    init(_ clLocation: CLLocation) {
        latitude = clLocation.coordinate.latitude
        longitude = clLocation.coordinate.longitude
    }
}
