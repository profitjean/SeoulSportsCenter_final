//
//  DiaryDataStructures.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 10/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import Foundation

struct Diary:Codable {
    let uid:String?
    let title:String?
    let date:TimeInterval?
    let content:String?
    let image_url:String?
}

