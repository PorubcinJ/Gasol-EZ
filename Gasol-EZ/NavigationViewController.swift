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

class NavigationViewController: UIViewController {
	
	var timer = Timer()
	
	
	
	@IBOutlet weak var progressView: UIProgressView!
	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super .viewDidLoad()
		timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(NavigationViewController.go), userInfo: nil, repeats: true)
	}
	
	func go() {
		progressView.progress += 0.00001
	}
	
}
