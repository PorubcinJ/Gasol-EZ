//
//  ButtonViewCell.swift
//  Gasol-EZ
//
//  Created by Jozef Porubcin on 7/18/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonCollectionViewCellDelegate: class {
	func didTapButton(_ button: UIButton, on cell: ButtonCollectionViewCell)
}

class ButtonCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var buttonImage: UIButton!
	
	weak var delegate: ButtonCollectionViewCellDelegate?
	
	
	@IBAction func buttonTapped(_ sender: UIButton) {
		delegate?.didTapButton(sender, on: self)
	}
}
