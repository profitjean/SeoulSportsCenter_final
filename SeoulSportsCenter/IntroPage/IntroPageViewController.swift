//
//  IntroPageViewController.swift
//  SeoulSportsCenter
//
//  Created by 김지현 on 20/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import PageControls

class IntroPageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: SnakePageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() { // 로드 후 서브뷰 레이아웃을 정리해주는 함수
        super.viewDidLayoutSubviews()
        // ImageViewController 를 ScrollView 에 추가
        let subIntroPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "IntroViewContent") as! subIntroPageViewController // as는 형지정
        
        // 스크롤뷰의 사이즈를 설정
        let contentSize = CGSize(width: subIntroPageViewController.view.frame.width, height: scrollView.bounds.height)
        scrollView.contentSize = contentSize
        scrollView.addSubview(subIntroPageViewController.view)
    }
}
    
    extension IntroPageViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
        // 컨텐ㄴ트오프셋 - 현재 얼마만큼 흘러갔는지
        let progress = CGFloat(page) + progressInPage
        pageControl.progress = progress
        //print(scrollView.contentOffset.x)
        if (self.pageControl.currentPage == 2 && CGFloat(self.pageControl.currentPage) * scrollView.bounds.width == scrollView.contentOffset.x) {
            NSLog("last")
            let VC = self.storyboard?.instantiateViewController(identifier: "VC") as! ViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }
    }
}
