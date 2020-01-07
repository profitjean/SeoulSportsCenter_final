//
//  FUIKakaoAuth.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 07/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import FirebaseUI

class FUIKakaoAuth:NSObject, FUIAuthProvider {
    var providerID: String?
    
    var shortName: String
    
    var signInLabel: String
    
    var icon: UIImage
    
    var buttonBackgroundColor: UIColor = UIColor(red: 1, green: 217/255.0, blue: 69/255.0, alpha: 1)// 배경색
    
    var buttonTextColor: UIColor // 글자색
    
    func signIn(withEmail email: String?, presenting presentingViewController: UIViewController?, completion: FUIAuthProviderSignInCompletionBlock? = nil) {
        
    }
    
    func signIn(withDefaultValue defaultValue: String?, presenting presentingViewController: UIViewController?, completion: FUIAuthProviderSignInCompletionBlock? = nil) {
        // 카카오 로그인 시작
        // 카카오 로그인이 끝나면 UID, email 얻기
        // 파이어베이스 로그인 하기
        // 현재 로그인 목록창 끄기
    }
    
    func signOut() {
        // 로그아웃
    }
    
    var accessToken: String?
    
    
}
