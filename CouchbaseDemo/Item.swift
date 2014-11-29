//
//  Item.swift
//  CouchbaseDemo
//
//  Created by Johnathan Grayson on 16/11/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import Foundation

class Item : CBLModel {
    
    @NSManaged var id : String?
    @NSManaged var title : String?
    @NSManaged var category : String?
    //@NSManaged var channels : [String]
    @NSManaged var owner : String?
    
}