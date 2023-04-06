//
//  LocationManager.swift
//  BlueMarble
//
//  Created by Tommy Chiapete on 4/12/21.
//


import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    // Publish the user's location so subscribers can react to updates
    @Published var lastKnownLocation: CLLocation? = nil
    private let manager = CLLocationManager()

    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
    }

    // If the status is authorized, have the manager call startUpdatinglocation()
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.manager.startUpdatingLocation()
        }
    }

    // Notify listeners that the user has a new location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastKnownLocation = locations.last
    }
}
