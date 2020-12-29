import CoreLocation
import PromiseKit

protocol LocationService {

    func authorize() -> Guarantee<LocationAuthState?>
    func fetchLocation() -> Guarantee<Location?>
}

// MARK: - Default Implementation

class DefaultLocationService: NSObject, LocationService {

    private let locationManager = CLLocationManager()
    private var locationRequestCompletions: [((Location?) -> Void)] = []
    private var authorizationCompletions: [((LocationAuthState?) -> Void)] = []

    var location: CLLocation? { locationManager.location }

    // MARK: - Initializers

    override init() {
        super.init()

        self.locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        self.locationManager.delegate = self
    }

    // MARK: - Instance Methods

    func authorize() -> Guarantee<LocationAuthState?> {
        guard CLLocationManager.locationServicesEnabled() else { return .value(.disabled) }

        if let authStatus = LocationAuthState(locationManager.authorizationStatus) {
            return .value(authStatus)
        }

        return Guarantee { completion in
            authorizationCompletions.append(completion)
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func fetchLocation() -> Guarantee<Location?> {
        return Guarantee { completion in
            let shouldRequestLocation = locationRequestCompletions.isEmpty
            locationRequestCompletions.append(completion)

            if shouldRequestLocation {
                locationManager.requestLocation()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension DefaultLocationService: CLLocationManagerDelegate {

    // MARK: - Instance Mehtods

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let state = LocationAuthState(status)
        while !authorizationCompletions.isEmpty {
            authorizationCompletions.removeFirst()(state)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        while !locationRequestCompletions.isEmpty {
            locationRequestCompletions.removeFirst()(locations.first.flatMap(Location.init))
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        while !locationRequestCompletions.isEmpty {
            locationRequestCompletions.removeFirst()(nil)
        }
    }
}
