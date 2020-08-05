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
    
    ///Might want to make these private
    var name: String
    var deskID: Int
    
    let id: UUID = UUID()
    
    init(name: String, deskID: Int) {
        self.name = name
        self.deskID = deskID
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getDeskID() -> Int {
        return self.deskID
    }
    
}
