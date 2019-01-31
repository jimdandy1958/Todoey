//
//  Category.swift
//  Todoey
//
//  Created by Mac on 1/29/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String =  ""
    @objc dynamic var colour: String = ""
    //This is the forward relationship from category to items    
    let items = List<Item>()
}
