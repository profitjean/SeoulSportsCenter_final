//
//  SportsStructures.swift
//  SeoulSportsCenter
//
//  Created by 김소연 on 2020/01/16.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import Foundation

struct ListProgramByPublicSportsFacilitiesService:Codable {
    let list_total:Int?
    let RESULT:Result?
    let row:[Row]?
}

struct Result:Codable {
    let CODE:String?
    let MESSAGE:String?
}

struct Row:Codable {
    let CENTER_NAME:String?
    let GROUND_NAME:String?
    let PROGRAM_NAME:String?
    let SUBJECT_NAME:String?
    let PLACE:String?
    let ADDRESS:String?
    let HOMEPAGE:String?
    let TEL:String?
    let CLASS_NAME:String?
    let TARGET:String?
    let WEEK:String?
    let CLASS_TIME:String?
    let FEE:String?
    
    let PARKING_SIDE:String?
    let ENTER_WAY:String?
    let ENTER_TERM:String?
}

