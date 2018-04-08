//
//  Category.swift
//  Todoey
//
//  Created by Gauri Bhagwat on 03/04/18.
//  Copyright © 2018 Development. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    var items = List<Item>()
}
