//
//  ViewController.swift
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
import KakaoOpenSDK
import Alamofire

class ViewController: UIViewController, FUIAuthDelegate {
    let token_url = "https://us-central1-seoulgym-78a0c.cloudfunctions.net/getJWT"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //카카오 로그인
        NotificationCenter.default.addObserver(self, selector: #selector(kakaoSessionChange), name: NSNotification.Name.KOSessionDidChange, object: nil)
    }
    
    //카카오 로그인 상태
    @objc func kakaoSessionChange() {
        guard let isOpened = KOSession.shared()?.isOpen() else {
            return
        }
        if isOpened {
            NSLog("로그인 상태")
            
            KOSessionTask.userMeTask{(error, user_me) in
                if let user = user_me, let user_id = user.id {
                    NSLog("\(user.id!)")
                    let login_info = TokenInfo(uid : user_id)
                    AF.request(self.token_url, method:.post, parameters: login_info, encoder: URLEncodedFormParameterEncoder(destination: .httpBody)).responseJSON{(response) in
                    //debugPrint(response)
                    //debugPrint(response.data)
                        do {
                            //functions를 이용해 받아온 토큰 파싱
                            let token_data = try JSONDecoder().decode(JWT.self, from: response.data!)
                            if token_data.error! == false {
                                NSLog(token_data.jwt!)
                                //토큰으로 firebase에 로그인
                                Auth.auth().signIn(withCustomToken: token_data.jwt!) {
                                    (result, error) in
                                    if let error = error {
                                        NSLog("로그인 실패")
                                    } else {
                                        NSLog("파이어 베이스 로그인 성공")
                                        
                                        if let current_user = Auth.auth().currentUser, let email = user.account!.email {
                                            current_user.updateEmail(to: email) { (error) in
                                                if let error = error {
                                                    NSLog("email update error")
                                                } else {
                                                    NSLog("email update complete")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }catch{
                            NSLog(error.localizedDescription)
                        }
                    }
                }
            }
            
        } else {
            NSLog("로그아웃 상태")
        }
    }

    // 구글 로그인 창
    let authUI = FUIAuth.defaultAuthUI()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = Auth.auth().currentUser{
            NSLog(user.uid)
            let mainViewController = self.storyboard?.instantiateViewController(identifier: "mainView") as! UITabBarController
        
            mainViewController.modalPresentationStyle = .fullScreen
            self.present(mainViewController, animated: false, completion: nil)
        }
        else {
            let providers:[FUIAuthProvider] = [
                FUIGoogleAuth()
            ]
            self.authUI!.providers = providers
            self.authUI!.delegate = self
            
            //let authViewController = self.authUI!.authViewController()
            let authViewController = customViewController(authUI: self.authUI!)
            
            authViewController.modalPresentationStyle = .fullScreen
            
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
    //로그인 후 파이어 베이스
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
    
    //카카오 로그인
    @IBAction func KakaoLogin(_ sender: Any) {
        guard let session = KOSession.shared() else { //session -> 로그인 관리
            return
        }
        
        if session.isOpen() {
            session.close()
        }
        
        session.open(completionHandler: {
            (error) -> Void in
            if !session.isOpen() {
                dump(error?.localizedDescription)
            }
        })
    }
    
    
}

