import CoreLocation
import PromiseKit

protocol LocationService {

    func authorize() -> Promise<Void>
    func fetchLocation() -> Promise<Location>
}

// MARK: - Default Implementation

class DefaultLocationService: NSObject, LocationService {

    private let locationManager = CLLocationManager()
    private var pendingAuthorizationPromises: [
        (promise: Promise<Void>, resolver: Resolver<Void>)
    ] = []
    private var pendinglocationRequestPromises: [
        (promise: Promise<Location>, resolver: Resolver<Location>)
    ] = []

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
        if LocationAuthState(locationManager.authorizationStatus) == .disabled {
            return .init(error: LocationServiceError.authError)
        }

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

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if case .enabled = LocationAuthState(manager.authorizationStatus) {
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

private enum LocationAuthState {

    case enabled
    case disabled
    case undefined

    init(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self = .enabled

        case .denied, .restricted:
            self = .disabled

        case .notDetermined:
            self = .undefined

        @unknown default:
            self = .disabled
        }
    }
}
