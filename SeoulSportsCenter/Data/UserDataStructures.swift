//
//  User.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 03/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

struct User:Codable {
    // 수정할 사용자 정보
    let name:String?
    let email:String?
    let image_url:String?
    
    /*
    init(name:String, email:String){
        self.name = name
        self.email = email
    }
    */
}
