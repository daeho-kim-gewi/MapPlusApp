//
//  UserLocationManager.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 12.03.21.
//

import Foundation
import CoreLocation

class UserLocationManager: NSObject, CLLocationManagerDelegate {

    private var manager: CLLocationManager = CLLocationManager()
    public static let shared = UserLocationManager()
    private let minAccuracy = kCLLocationAccuracyHundredMeters
    
    public var currentLocation: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = minAccuracy
        manager.activityType = .other
        manager.distanceFilter = 250.0
        
        manager.requestWhenInUseAuthorization()
    }

    func isAvailabe() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
    }

    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .notDetermined:
            // report error, do something
            print("error - no location available")
        default:
            // location is allowed, start monitoring
            manager.startUpdatingLocation()
        }
    }

    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        manager.stopUpdatingLocation()
        // do something with the error
    }

    private func locationManager(manager: CLLocationManager,
                                 didUpdateLocations locations: [CLLocation]) {
        if let locationObj = locations.last {
            if locationObj.horizontalAccuracy < minAccuracy {

                // report location somewhere else
                self.currentLocation = locationObj
                
                print("\(locationObj.coordinate.longitude) \(locationObj.coordinate.latitude)")
            }
        }
    }
}
