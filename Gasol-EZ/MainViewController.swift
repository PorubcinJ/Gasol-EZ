//
//  MainViewController.swift
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

class MainViewController: UIViewController {

    let location: LocationManager = LocationManager()
    var locationLatitude: String!
    var locationLongidude: String!

    var gasStation: GasStation!
    var gasStations: [GasStation] = []

    var radiusMilage: Double! {
        didSet {
            radiusMilage = radiusMilage * 1000 * 1.609344
            print(radiusMilage)
        }
    }

    var didFindLocation: Bool = false

    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var gasButton: UIButton!

    var radius: Double! = 1

    override func viewDidLoad() {

        location.requestAccess = .requestWhenInUseAuthorization //default is .requestAlwaysAuthorization

        location.getLocation(detectStyle: .Once, completion: { (loc) in
            print(loc.currentLocation.coordinate.latitude.description)
            print(loc.currentLocation.coordinate.longitude.description)

            self.locationLatitude = loc.currentLocation.coordinate.latitude.description
            self.locationLongidude = loc.currentLocation.coordinate.longitude.description
            print("Something")
        }, authorizationChange: { (status) in
            //optional
            print(status)
        })
        print("Finished")
        
        fadeIn()
    }

	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	func fadeIn() {
		tutorialLabel.alpha = 0
		
		UIView.animate(withDuration: 20) {
			self.tutorialLabel.alpha = 1
		}
	}

    func openMapForPlace() {
        print(gasStations)

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

    @IBAction func gasButtonPressed(_ sender: UIButton) {
        print("Button pressed")

        let locationCoordinates: String = "\(locationLatitude!),\(locationLongidude!)"
        let apiToContact = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationCoordinates)&rankby=distance&type=gas_station&key=\(Constants.Alamofire.gmPlacesApiKey)"

        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let gasStationData = json["results"]

                    print(gasStationData)

                    for i in 0..<gasStationData.count {
                        self.gasStations.append(GasStation(json: gasStationData[i]))
                    }
                    print(self.gasStations)
                    self.openMapForPlace()

                }
            case .failure(let error):
                print(error)
            }
        }
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {

            print("segmented control value changed to 0: radius = 0.5")
            radius = 0.5

        } else if sender.selectedSegmentIndex == 1 {
            print("segmented control value changed to 1: radius = 1")
            radius = 1.0

        } else {
            print("segmented control value changed to 2: radius = 5")
            radius = 5.0
        }
    }
}








