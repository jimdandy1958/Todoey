//
//  StudentInfo.swift
//  JWMinistry
//
//  Created by Mac on 2/3/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import Foundation
import RealmSwift

class ServiceReport: Object {

    @objc dynamic var name: String = "Name"
    @objc dynamic var month: String = "Month"
    @objc dynamic var placements: Int = 0
    @objc dynamic var videos: Int = 0
    @objc dynamic var hours: Int = 0
    @objc dynamic var returnVisits: Int = 0
    @objc dynamic var bibleStudies: Int = 0
    @objc dynamic var notes: String = "notes"
}
