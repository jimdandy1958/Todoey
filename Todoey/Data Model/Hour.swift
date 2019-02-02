//
//  Hour.swift
//  JWMinistry
//
//  Created by Mac on 2/1/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//


import Foundation
import RealmSwift

class Hour: Object {
    
    @objc dynamic var hourValue: Int = 0
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //the reverse relationship of hours to the Month view
    var parentCategory = LinkingObjects(fromType: Month.self, property: "hours")
}

