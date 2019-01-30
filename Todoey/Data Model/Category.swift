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

    //This is the forware relationship from category to items
    //ITEMS IS LIKE AN ARRAY
    
    let items = List<Item>()
}
