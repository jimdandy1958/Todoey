//
//  Month.swift
//  JWMinistry
//
//  Created by Mac on 2/1/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import Foundation
import RealmSwift

class Month: Object {
    @objc dynamic var monthName: String =  ""
    @objc dynamic var colour: String = ""
    //This is the forward relationship from category to items
    let hours = List<Hour>()
}
