//
//  MainViewController.swift
//  Gasol-EZ
//
//  Created by Jozef Porubcin and Matt Ziminski on 7/5/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import SwiftyJSON
import MapKit
import JLocationKit

final class MainViewController: UICollectionViewController{
	
	var button: Button?
	
	var buttons = [Button](){
		didSet {
			collectionView?.reloadData()
		}
	}
	
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if restorationIdentifier == "addButton" {
			print("+ button tapped")
		}
	}

    var didFindLocation: Bool = false
    var radius: Double! = 1

    override func viewDidLoad()
	{
		location.requestAccess = .requestWhenInUseAuthorization //default is .requestAlwaysAuthorization
		
		location.getLocation(detectStyle: .Once, completion: { (loc) in
			print(loc.currentLocation.coordinate.latitude.description)
			print(loc.currentLocation.coordinate.longitude.description)
			
			self.locationLatitude = loc.currentLocation.coordinate.latitude.description
			self.locationLongidude = loc.currentLocation.coordinate.longitude.description
		}, authorizationChange: { (status) in
			//optional
			print(status)
		})
		print("Finished")
		super.viewDidLoad()
		buttons = CoreDataHelper.retrieveButtons()
    }


    func openMapForPlace() {
        let latitude: CLLocationDegrees = CLLocationDegrees(gasStations[0].locationLatitude)
        let longitude: CLLocationDegrees = CLLocationDegrees(gasStations[0].locationLongitude)

        let regionDistance:CLLocationDistance = 70000

        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\((gasStations[0].name)!)"
        mapItem.openInMaps(launchOptions: options)
    }
	
    @IBAction func firstButtonPressed(_ sender: UIButton) {
        print("Button pressed")
        let locationCoordinates: String = "\(locationLatitude!),\(locationLongidude!)"
        let apiToContact = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationCoordinates)&rankby=distance&keyword=\(button?.keyword ?? button?.keyword)&opennow=true&key=\(Constants.Alamofire.gmPlacesApiKey)"

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
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print(buttons.count)
		return buttons.count
	}
	
override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as! ButtonCollectionViewCell
		//let item = indexPath.item
		let button = buttons[indexPath.row]
	
//		cell.buttonImage.text = button.keyword
	
		let keyWord = button.keyword
//		cell.buttonImage.text = button.url
		return cell
	}	
	
	@IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
		self.buttons = CoreDataHelper.retrieveButtons()
	}
}







