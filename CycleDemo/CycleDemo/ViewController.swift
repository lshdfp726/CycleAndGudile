//
//  ViewController.swift
//  CycleDemo
//
//  Created by lsh726 on 2018/1/16.
//  Copyright © 2018年 liusonghong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let dataArray = ["1", "2", "3", "4"]

        //添加轮播图页面
        let cycleView = CycleView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300), 5.0)
        cycleView.cycleDataArray = dataArray
        self.view.addSubview(cycleView)
        cycleView.addTapGesture { (str) in
            print("当前是第\(str)张照片")
        }


        //添加引导页面
        let view = WelcomeView.init(frame: UIScreen.main.bounds)
        view.welcomeImageArray = dataArray
        self.view.addSubview(view)
        view.addTapGesture {
            [weak weakV = view] in
            weakV?.alpha = 0.0
            weakV?.removeFromSuperview()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

