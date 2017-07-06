//
//  MainViewController.swift
//  Gasol-EZ
//
//  Created by Jozef Porubcin on 7/5/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		fadeIn()
	}
	
	@IBOutlet weak var tutorialLabel: UILabel!
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBOutlet weak var gasButton: UIButton!
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	func fadeIn() {
		tutorialLabel.alpha = 0
		
		UIView.animate(withDuration: 20) {
			self.tutorialLabel.alpha = 1
		}
	}
}
