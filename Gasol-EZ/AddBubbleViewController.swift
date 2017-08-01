//
//  AddBubbleViewController.swift
//  Gasol-EZ
//
//  Created by Jozef Porubcin on 7/13/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit

class AddBubbleViewController: UIViewController {
	
	var button: Button?
	
	@IBOutlet weak var keyWord: UITextField!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let button = button {
			keyWord.text = button.keyword
		} else {
			keyWord.text = ""
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "save" {
			let button = self.button ?? CoreDataHelper.newButton()
			button.keyword = keyWord.text ?? ""
			CoreDataHelper.saveButton()
		}
	}
}
