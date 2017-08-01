//
//  GasStation.swift
//  Gasol-EZ
//
//  Created by Jozef Porubcin on 7/6/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GasStation {
    var locationLatitude: Double!
    var locationLongitude: Double!
    var name: String!
    var iconImageUrl: String!
    var vicinity: String!

    init(json: JSON) {
        self.locationLatitude = json["geometry"]["location"]["lat"].doubleValue
        self.locationLongitude = json["geometry"]["location"]["lng"].doubleValue
        self.name = json["name"].stringValue
        self.iconImageUrl = json["icon"].stringValue
        self.vicinity = json["vicinity"].stringValue
    }
}
