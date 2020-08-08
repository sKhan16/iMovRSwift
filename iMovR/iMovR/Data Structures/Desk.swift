//
//  Desk.swift
//  iMovR
//
//  Created by Shakeel Khan on 8/4/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
/*
 Class that represents a desk. It is uniquely identifiable via a UUID
 */
import Foundation

struct Desk: Identifiable {
    
    var name: String
    let id: Int
    
    init(name: String, deskID: Int) {
        self.name = name
        self.id = deskID
    }
    
    
    func getName() -> String {
        return self.name
    }
    
    func getDeskID() -> Int {
        return self.id
    }
    
}
