//
//  Item.swift
//  Todoey
//
//  Created by Mac on 1/29/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    //the reverse relationship of items to the category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
