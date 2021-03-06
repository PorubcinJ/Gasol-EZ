//
//  MainViewController.swift
//  Gasol-EZ
//
//  Created by Jozef Porubcin on 7/5/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import SwiftyJSON
import MapKit
import JLocationKit
import CoreLocation

final class MainViewController: UICollectionViewController {
	
	var buttons = [Button](){
		didSet {
			collectionView?.reloadData()
		}
	}
	
	@IBOutlet weak var addButton: UIBarButtonItem!
	
	let location: LocationManager = LocationManager()
	let locationManager = CLLocationManager()
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
		if segue.identifier == "addButton" {
			//
			
		}
	}
	
	var didFindLocation: Bool = false
	var radius: Double! = 1
	
	func requestForLocation() {
		addButton.isEnabled = true
		if CLLocationManager.locationServicesEnabled() {
			switch(CLLocationManager.authorizationStatus()) {
			case .notDetermined:
				self.location.requestAccess = .requestWhenInUseAuthorization
				self.addButton.isEnabled = false
				//requestForLocation()
			case .restricted, .denied:
				let alertController = UIAlertController(title: "Alert", message: "Oops, it seems that you have denied our request to use your location. Without your location, this app will not be able to navigate you accurately. We don't review or track any user's location information; we respect your privacy. TO ENABLE LOCATION SERVIES FOR THIS APP, you will need to go to Settings, Privacy, Location Services, One Tap, and allow location services. Thank you!", preferredStyle: UIAlertControllerStyle.alert)
				let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler:  {
					UIAlertAction in
					print("In here")
					self.addButton.isEnabled = false
				})
				alertController.addAction(okAction)
				self.present(alertController, animated: true, completion: {
					self.addButton.isEnabled = false
				})
			case .authorizedAlways, .authorizedWhenInUse:
				print("Access")
			default:
				break
			}
		} else {
			addButton.isEnabled = false
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		
		requestForLocation()
		
		
		
		//if self.locationLatitude == nil {
		//	location.requestAccess = .requestWhenInUseAuthorization
		//} else {
		
		 //default is .requestAlwaysAuthorization
		
		
		location.getLocation(detectStyle: .Once, completion: { (loc) in
			
			print(loc.currentLocation.coordinate.latitude.description)
			print(loc.currentLocation.coordinate.longitude.description)
			self.addButton.isEnabled = true
			self.locationLatitude = loc.currentLocation.coordinate.latitude.description
			self.locationLongidude = loc.currentLocation.coordinate.longitude.description
		}, authorizationChange: { (status) in
			//optional
			print(status)
		})
		buttons = CoreDataHelper.retrieveButtons()
	}
	
	
	func openMapForPlace() {
		if gasStations.count < 1 {
			return
		}
		
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
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print(buttons.count)
		return buttons.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as! ButtonCollectionViewCell
		let button = buttons[indexPath.row]
		cell.delegate = self
		let keyword = buttons[indexPath.row].keyword
		cell.keywordLabel.text = button.keyword
		
		return cell
	}
	
	@IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
		self.buttons = CoreDataHelper.retrieveButtons()
	}
	
	
}

extension MainViewController : ButtonCollectionViewCellDelegate {
	func didTapButton(_ button: UIButton, on cell: ButtonCollectionViewCell) {
		guard let indexPath = collectionView?.indexPath(for: cell)
			else { return }
		
		guard let keyword = buttons[indexPath.row].keyword else {
			return
		}
		
		guard let finalKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
			return
		}
		
		guard let locationLatitude = locationLatitude, let locationLongidude = locationLongidude else {
			print("The coordinates are nil")
			locationManager.requestLocation()
			return
		}
		
		
		
		let locationCoordinates: String = "\(locationLatitude),\(locationLongidude)"
		let apiToContact = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationCoordinates)&rankby=distance&keyword=\(finalKeyword)&opennow=true&key=\(Constants.Alamofire.gmPlacesApiKey)"
		print(apiToContact)
		Alamofire.request(apiToContact).validate().responseJSON() { response in
			switch response.result {
			case .success:
				if let value = response.result.value {
					let json = JSON(value)
					let gasStationData = json["results"]
					self.gasStations.removeAll()
					for i in 0..<gasStationData.count {
						self.gasStations.append(GasStation(json: gasStationData[i]))
					}
					self.openMapForPlace()
				}
			case .failure(let error):
				print(error)
			}
			//activityIndicatorItem.stopAnimating()
		}
	}
	
	func delete(cell: ButtonCollectionViewCell) {
		if let indexPath = self.collectionView?.indexPath(for: cell) {
			CoreDataHelper.delete(button: buttons[indexPath.row])
			buttons = CoreDataHelper.retrieveButtons()
		}
	}
}
