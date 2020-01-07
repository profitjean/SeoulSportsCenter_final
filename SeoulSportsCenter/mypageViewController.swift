//
//  mypageViewController.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 03/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CodableFirebase


class mypageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //로그인
    let authUI = FUIAuth.defaultAuthUI()
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        NSLog("login complete")
        if let error = error {
            NSLog(error.localizedDescription)
            return
        }
        if let user = Auth.auth().currentUser {
            let user_id = user.uid
            
            var ref = Database.database().reference()
            ref.child("users").child(user_id).observeSingleEvent(of: .value, with: {
                (snapshot) in
                
                if let value = snapshot.value{
                    do {
                        let user = try FirebaseDecoder().decode(User.self, from: value)
                        
                        NSLog("정보 있음")
                        dump(user)
                    } catch let error {
                        NSLog(error.localizedDescription)
                        NSLog("추가 정보 입력 필요")
                        
                        let user = User(name: "text", email: "test@test.com")
                        let data = try! FirebaseEncoder().encode(user)
                        ref.child("users").child(user_id).setValue(data)
                    }
                   
                }
            }) {
                (error) in NSLog(error.localizedDescription)
            }
        }
    }
    
    @IBAction func btnLogout(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        do {
            try Auth.auth().signOut()
            NSLog("로그아웃 성공")
        } catch {
            NSLog("로그아웃 성공")
        }
    }
    
}
