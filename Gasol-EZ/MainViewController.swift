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

final class MainViewController: UICollectionViewController {
	
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
		if segue.identifier == "addButton" {
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
		
		if gasStations.count < 1 {
			print("No places found in radius")
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
		cell.buttonImage.setTitle("\(keyword!)", for: .normal)
		
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
		
		let locationCoordinates: String = "\(locationLatitude!),\(locationLongidude!)"
		let apiToContact = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationCoordinates)&rankby=distance&keyword=\(keyword)&opennow=true&key=\(Constants.Alamofire.gmPlacesApiKey)"
		print(apiToContact)
		Alamofire.request(apiToContact).validate().responseJSON() { response in
			switch response.result {
			case .success:
				if let value = response.result.value {
					let json = JSON(value)
					let gasStationData = json["results"]
					print("About to print gas station data")
					//print(gasStationData)
					
					self.gasStations.removeAll()
					for i in 0..<gasStationData.count {
						self.gasStations.append(GasStation(json: gasStationData[i]))
					}
					//print(self.gasStations)
					self.openMapForPlace()
					
				}
			case .failure(let error):
				print(error)
			}
		}
		
		
	}
	
	func delete(cell: ButtonCollectionViewCell) {
		if let indexPath = self.collectionView?.indexPath(for: cell) {
			//buttons.remove(at: indexPath.item)
			CoreDataHelper.delete(button: buttons[indexPath.row])
			buttons = CoreDataHelper.retrieveButtons()
		}
	}
}
