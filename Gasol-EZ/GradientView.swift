//
//  View View Controller.swift
//  Gasol-EZ
//
//  Created by Jozef Porubcin on 8/7/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class GradientView: UIView {
	
	@IBInspectable var startColor =  UIColor(red: 128.0/255.0, green: 242.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
	@IBInspectable var endColor = UIColor(red: 0.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
	@IBInspectable var startLocation: Double = 0.05 { didSet { updateLocations() }}
	@IBInspectable var endLocation: Double = 0.95 { didSet { updateLocations() }}
	@IBInspectable var horizontalMode: Bool = false { didSet { updatePoints() }}
	@IBInspectable var diagonalMode: Bool = false { didSet { updatePoints() }}
	
	override class var layerClass: AnyClass {return CAGradientLayer.self}
	
	var gradientLayer: CAGradientLayer {return layer as! CAGradientLayer}
	
	func updatePoints() {
		if horizontalMode {
			gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
			gradientLayer.endPoint = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
		} else {
			gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
			gradientLayer.endPoint = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
		}
	}
	func updateLocations() {
		gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
	}
	func updateColors() {
		gradientLayer.colors = [startColor, endColor]
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		updatePoints()
		updateLocations()
		updateColors()
	}
}
