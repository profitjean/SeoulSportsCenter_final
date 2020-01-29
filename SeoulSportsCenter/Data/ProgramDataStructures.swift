//
//  ProgramDataStructures.swift
//  SeoulSportsCenter
//
//  Created by 김소연 on 2020/01/14.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import Foundation

// 찜한 프로그램 구조체
struct MyProgram:Codable {
    /*let className:String?
    let centerName:String?
    let subject:String?
    let date:String?
    let time:String?*/
    
    
    let center:String?
    //let GROUND_NAME:String?
    let program:String?
    let subject:String?
    //let PLACE:String?
    let address:String?
    let homepage:String?
    //let TEL:String?
    //let CLASS_NAME:String?
    let target:String?
    let week:String?
    let time:String?
    let tel:String?
    //let FEE:String?
}

/*"program":selected_program[0].PROGRAM_NAME ?? "",
"center":selected_program[0].CENTER_NAME ?? "",
"subject":selected_program[0].SUBJECT_NAME ?? "",
"target":selected_program[0].TARGET ?? "",
"week":selected_program[0].WEEK ?? "",
"time":selected_program[0].CLASS_TIME ?? "",
"address":selected_program[0].ADDRESS ?? ""**/
