//
//  NavigationViewController.swift
//  Gasol-EZ
//
//  Created by Jozef Porubcin on 7/5/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsCore
import GooglePlacePicker
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0

    var didFindLocation: Bool = false

    override func viewDidLoad() {

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()

        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
    }

}

extension MapViewController: CLLocationManagerDelegate {

    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        didFindLocation = true


        if didFindLocation == true {

            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }

        currentLocation = locations.last!
        print("Location: \(String(describing: currentLocation))")

//        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                              longitude: location.coordinate.longitude,
//                                              zoom: zoomLevel)
//
//        if mapView.isHidden {
//            mapView.isHidden = false
//            mapView.camera = camera
//        } else {
//            mapView.animate(to: camera)
//        }


        print("\n\n ** Location: \((currentLocation?.coordinate.latitude)!), \((currentLocation?.coordinate.longitude)!) \n\n")

        let locationCoordinates: String = "\(String(describing: (currentLocation?.coordinate.latitude)!)),\(String(describing: (currentLocation?.coordinate.longitude)!))"

        let apiToContact = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationCoordinates)&radius=1000&type=gas_station&key=\(Constants.Alamofire.gmPlacesApiKey)"

        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)

                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

