//
//  Item.swift
//  CouchbaseDemo
//
//  Created by Johnathan Grayson on 16/11/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import Foundation

class Item {
    var id : String = ""
    var title : String = ""
    var category : String = ""
    
    init(title: String, category: String) {
        self.title = title
        self.category = category
    }
    
    init(id: String, title: String, category: String) {
        self.id = id
        self.title = title
        self.category = category
    }
}