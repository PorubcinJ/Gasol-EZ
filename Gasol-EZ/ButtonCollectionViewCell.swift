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
	
	func delete(cell: ButtonCollectionViewCell)
}

class ButtonCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var buttonImage: UIButton!
	
	@IBOutlet weak var deleteButton: UIButton!
	
	@IBOutlet weak var keywordLabel: UILabel!
	
	weak var delegate: ButtonCollectionViewCellDelegate?
	
	@IBAction func deleteButtonTapped(_ sender: UIButton) {
		delegate?.delete(cell: self)
	}
	@IBAction func buttonTapped(_ sender: UIButton) {
		delegate?.didTapButton(sender, on: self)
	}
	
	
}
