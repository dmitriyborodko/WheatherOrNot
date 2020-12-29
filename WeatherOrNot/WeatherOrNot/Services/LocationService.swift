import CoreLocation
import PromiseKit

protocol LocationService {

    func authorize() -> Promise<Void>
    func fetchLocation() -> Promise<Location>
}

// MARK: - Default Implementation

class DefaultLocationService: NSObject, LocationService {

    private enum LocationAuthState {
        case enabled
        case disabled

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

    private let locationManager = CLLocationManager()
    private var pendingAuthorizationPromises: [
        (promise: Promise<Void>, resolver: Resolver<Void>)
    ] = []
    private var pendinglocationRequestPromises: [
        (promise: Promise<Location>, resolver: Resolver<Location>)
    ] = []

    var location: CLLocation? { locationManager.location }

    // MARK: - Initializers

    override init() {
        super.init()

        self.locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        self.locationManager.delegate = self
    }

    // MARK: - Instance Methods

    func authorize() -> Promise<Void> {
        guard CLLocationManager.locationServicesEnabled() else { return .init(error: LocationServiceError.authError) }
        if LocationAuthState(locationManager.authorizationStatus) == .enabled { return .value(()) }

        let pending = Promise<Void>.pending()
        pendingAuthorizationPromises.append(pending)

        locationManager.requestWhenInUseAuthorization()
        return pending.promise
    }

    func fetchLocation() -> Promise<Location> {
        let shouldRequestLocation = pendinglocationRequestPromises.isEmpty

        let pending = Promise<Location>.pending()
        pendinglocationRequestPromises.append(pending)

        if shouldRequestLocation {
            locationManager.requestLocation()
        }
        return pending.promise
    }
}

// MARK: - CLLocationManagerDelegate

extension DefaultLocationService: CLLocationManagerDelegate {

    // MARK: - Instance Mehtods

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if case .enabled = LocationAuthState(status) {
            while !pendingAuthorizationPromises.isEmpty {
                pendingAuthorizationPromises.removeFirst().resolver.fulfill(())
            }
        } else {
            while !pendingAuthorizationPromises.isEmpty {
                pendingAuthorizationPromises.removeFirst().resolver.reject(LocationServiceError.authError)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first.flatMap(Location.init) {
            while !pendinglocationRequestPromises.isEmpty {
                pendinglocationRequestPromises.removeFirst().resolver.fulfill(location)
            }
        } else {
            while !pendinglocationRequestPromises.isEmpty {
                pendinglocationRequestPromises.removeFirst().resolver.reject(LocationServiceError.noLocationFound)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        while !pendinglocationRequestPromises.isEmpty {
            pendinglocationRequestPromises.removeFirst().resolver.reject(LocationServiceError.noLocationFound)
        }
    }
}

enum LocationServiceError: Error {

    case authError
    case noLocationFound
}
