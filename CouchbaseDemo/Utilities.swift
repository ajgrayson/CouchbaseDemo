//
//  Utilities.swift
//  CouchbaseDemo
//
//  Created by Johnathan Grayson on 16/11/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import Foundation

extension CBLView {
    // Just reorders the parameters to take advantage of Swift's trailing-block syntax.
    func setMapBlock(version: String, mapBlock: CBLMapBlock) -> Bool {
        return setMapBlock(mapBlock, version: version)
    }
}