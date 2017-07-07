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

    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var gasButton: UIButton!

    var radius: Double! = 1

	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		fadeIn()
	}

	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.toMapNavigationViewController {
            print("segue to Map Navigation View Controller")

            let mapViewController = segue.destination as! MapViewController
            mapViewController.radiusMilage = radius
        }
    }
	
	func fadeIn() {
		tutorialLabel.alpha = 0
		
		UIView.animate(withDuration: 20) {
			self.tutorialLabel.alpha = 1
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
