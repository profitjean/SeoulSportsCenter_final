//
//  FUIKakaoAuth.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 07/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import FirebaseUI
import KakaoOpenSDK
import Alamofire

class FUIKakaoAuth:NSObject, FUIAuthProvider {
    var providerID: String? = "Kakaotalk"
    
    var shortName: String = "Kakaotalk"
    
    var signInLabel: String = "Sign in with KakaoTalk"
    
    var icon: UIImage = UIImage(named: "btn_kakao")!
    
    var buttonBackgroundColor: UIColor = UIColor(red: 1, green: 217/255.0, blue: 69/255.0, alpha: 1)// 배경색
    
    var buttonTextColor: UIColor = .black // 글자색
    
    func signIn(withEmail email: String?, presenting presentingViewController: UIViewController?, completion: FUIAuthProviderSignInCompletionBlock? = nil) {
        
    }
    
    func signIn(withDefaultValue defaultValue: String?, presenting presentingViewController: UIViewController?, completion: FUIAuthProviderSignInCompletionBlock? = nil) {
        
        guard let session = KOSession.shared() else {
            return
        }
        
        if session.isOpen() {
            session.close()
        }
        
        let activityView = FUIAuthBaseViewController.addActivityIndicator(presentingViewController!.view)
        activityView.startAnimating()
        
        session.open { (error) in
            if let error = error {
                NSLog("로그인 실패")
            } else {
                NSLog("로그인 성공")
                
                KOSessionTask.userMeTask{ (error,user_me) in
                    if let error = error{
                        NSLog(error.localizedDescription)
                    }
                    if let user = user_me {
                        let uid = user.id!
                        NSLog("user id : \(uid)")
                        let login_info = TokenInfo(uid : user.id!)
                        AF.request("https://us-central1-seoulgym-78a0c.cloudfunctions.net/getJWT", method:.post, parameters: login_info, encoder: URLEncodedFormParameterEncoder(destination: .httpBody)).responseJSON { (response) in
                            do {
                                debugPrint(response)
                                let token_data = try JSONDecoder().decode(JWT.self, from: response.data!)
                                if token_data.error! == false {
                                    NSLog(token_data.jwt!)
                                    //토큰으로 firebase에 로그인
                                    Auth.auth().signIn(withCustomToken: token_data.jwt!) {
                                        (result, error) in
                                        if let error = error {
                                            debugPrint(error)
                                        } else {
                                            if let current_user = Auth.auth().currentUser, let email = user.account!.email {
                                                current_user.updateEmail(to: email) { (error) in
                                                    if let error = error {
                                                        NSLog("email update error")
                                                    } else {
                                                        NSLog("email update complete")
                                                    }
                                                    activityView.stopAnimating()
                                                    presentingViewController?.dismiss(animated: true, completion: nil)
                                                }
                                            }
                                        }
                                    }
                                }
                            } catch {
                                NSLog(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func signOut() {
        // 로그아웃
    }
    
    var accessToken: String?
    
}
