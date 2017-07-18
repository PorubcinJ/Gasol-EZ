//
//  CoreDataHelper.swift
//  Gasol-EZ
//
//  Created by Jozef Porubcin on 7/14/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
	static let appDelegate = UIApplication.shared.delegate as! AppDelegate
	static let persistentContainer = appDelegate.persistentContainer
	static let managedContext = persistentContainer.viewContext
	
	static func newButton() -> Button {
		let button = NSEntityDescription.insertNewObject(forEntityName: "Button", into: managedContext) as! Button
		return button
	}
	
	static func saveButton() {
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not save \(error)")
		}
	}
	
	static func delete(button: Button) {
		managedContext.delete(button)
		saveButton()
	}
	
	static func retrieveButtons() -> [Button] {
		let fetchRequest = NSFetchRequest<Button>(entityName: "Button")
		do {
			let results = try managedContext.fetch(fetchRequest)
			return results
		} catch let error as NSError {
			print("Could not fetch \(error)")
		}
		return []
	}
}
