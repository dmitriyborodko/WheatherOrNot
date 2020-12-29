import CoreLocation

enum LocationAuthState {
    case enabled
    case disabled
}

extension LocationAuthState {

    init?(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self = .enabled

        case .denied, .restricted:
            self = .disabled

        case .notDetermined:
            return nil

        @unknown default:
            return nil
        }
    }
}
