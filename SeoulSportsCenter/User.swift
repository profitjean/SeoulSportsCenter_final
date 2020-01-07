//
//  User.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 03/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

struct User:Codable {
    let name:String
    let email:String
    
    init(name:String, email:String){
        self.name = name
        self.email = email
    }
}
