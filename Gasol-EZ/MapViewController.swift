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
import MapKit
import JLocationKit

class MapViewController: UIViewController {

    let location: LocationManager = LocationManager()

    var gasStation: GasStation!
    var gasStations: [GasStation] = []

    var radiusMilage: Double! {
        didSet {
            radiusMilage = radiusMilage * 1000 * 1.609344
            print(radiusMilage)
        }
    }

    var didFindLocation: Bool = false

    override func viewDidLoad() {
        
    }

    func openMapForPlace() {

        let latitude: CLLocationDegrees = CLLocationDegrees(gasStations[0].locationLatitude)
        let longitude: CLLocationDegrees = CLLocationDegrees(gasStations[0].locationLongitude)

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(gasStations[0].name)"
        mapItem.openInMaps(launchOptions: options)
    }
}

//extension MapViewController: CLLocationManagerDelegate {
//
//    // Handle incoming location events.
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        didFindLocation = true
//
//
//        if didFindLocation == true {
//
//            locationManager.stopUpdatingLocation()
//            locationManager.delegate = nil
//        }
//
//        currentLocation = locations.last!
//        print("Location: \(String(describing: currentLocation))")
//
//
//        print("\n\n ** Location: \((currentLocation?.coordinate.latitude)!), \((currentLocation?.coordinate.longitude)!) \n\n")
//
//        let locationCoordinates: String = "\(String(describing: (currentLocation?.coordinate.latitude)!)),\(String(describing: (currentLocation?.coordinate.longitude)!))"
//
//        let apiToContact = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationCoordinates)&rankby=distance&type=gas_station&key=\(Constants.Alamofire.gmPlacesApiKey)"
//
//        Alamofire.request(apiToContact).validate().responseJSON() { response in
//            switch response.result {
//            case .success:
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    let gasStationData = json["results"]
//
//                    print(gasStationData)
//
//                    for i in 0..<gasStationData.count {
//                        self.gasStations.append(GasStation(json: gasStationData[i]))
//                    }
//                    print(self.gasStations)
//                    self.openMapForPlace()
//
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    // Handle authorization for the location manager.
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .restricted:
//            print("Location access was restricted.")
//        case .denied:
//            print("User denied access to location.")
//            // Display the map using the default location.
//            mapView.isHidden = false
//        case .notDetermined:
//            print("Location status not determined.")
//        case .authorizedAlways: fallthrough
//        case .authorizedWhenInUse:
//            print("Location status is OK.")
//        }
//    }
//
//    // Handle location manager errors.
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//        print("Error: \(error)")
//    }
//}

