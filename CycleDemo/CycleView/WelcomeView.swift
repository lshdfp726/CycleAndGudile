//
//  WelcomeView.swift
//  QianMi
//
//  Created by lsh726 on 2018/1/11.
//  Copyright © 2018年 liusonghong. All rights reserved.
//

import UIKit
import AVFoundation

class WelcomeView: CycleSuperView {
    var ClickCurrentView: (() -> Void)? //点击事件回调

    var welcomeImageArray: Array<String>? {//初始化赋值
        didSet {
            scrollView?.contentSize = CGSize.init(width: CGFloat((welcomeImageArray?.count)!) * width(object: self), height: height(object: self))
            pageControl?.numberOfPages = (welcomeImageArray?.count)!
            initialImageView()//初始化背景图片
        }
    }


    //只要重写父类的图片初始化就可以了。其他逻辑不用管
    override func initialImageView() {
        for (index, obj) in (welcomeImageArray?.enumerated())! {
            let imageView = UIImageView.init(frame: CGRect.init(x: left_x(object: self) + width(object: self) * CGFloat(index), y: top_y(object: self), width: width(object: self), height: height(object: self)))
            imageView.image = UIImage.init(imageLiteralResourceName: obj)
            imageView.tag = index
            scrollView?.addSubview(imageView)
        }
    }


    //增加点击事件
    func addTapGesture(_ ClickAction: @escaping ()-> Void) {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(ClickView))
        self.addGestureRecognizer(tapGesture)
        ClickCurrentView = ClickAction
    }


    @objc func ClickView() {
        if self.pageControl?.currentPage == (self.welcomeImageArray?.count)! - 1 {
            if self.ClickCurrentView != nil {
                self.ClickCurrentView!()
            }
        }
    }

}







