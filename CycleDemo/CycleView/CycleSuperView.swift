//
//  CycleSuperView.swift
//  QianMi
//
//  Created by lsh726 on 2018/1/13.
//  Copyright © 2018年 liusonghong. All rights reserved.
//

import UIKit

/**
    父类类似于抽象类，主要承担完成UI 绘制，以及一些滑动逻辑判断的处理
    数据源和回调等工作都有子类来完成
 */

class CycleSuperView: UIView, UIScrollViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //底部背景scrollView
    lazy var scrollView: UIScrollView? = {
        return initalScrollView()
    }()

    //pageView 控制条
    lazy var pageControl: UIPageControl? = {
        let control: UIPageControl? = initalPageControl()
        return control
    }()


    /**  子类需要重写数据源方法和图片方法，因为数据源和图片是未知的不确定的 */
    fileprivate var dataArray: Array<String>? {//
        didSet {
            scrollView?.contentSize = CGSize.init(width: CGFloat((dataArray?.count)! + 2) * width(object: self), height: height(object: self))
            pageControl?.numberOfPages = (dataArray?.count)!
            initialImageView()//初始化背景图片
        }
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /** 指定初始化 */
    override init(frame: CGRect) {
        super.init(frame: frame)

    }


    /** 初始化 ScrollView*/
    @discardableResult
    fileprivate func initalScrollView() -> UIScrollView {
        let  scrol = UIScrollView.init(frame: self.bounds)
        scrol.delegate = self
        scrol.tag = 1000
        scrol.showsHorizontalScrollIndicator = false
        scrol.bounces = false
        scrol.isPagingEnabled = true
        scrol.showsVerticalScrollIndicator = false;
        self.addSubview(scrol)

        return scrol
    }


    /** 初始化底层图片 */
    open func initialImageView() {
        for (index, obj) in (dataArray?.enumerated())! {
            let imageView = UIImageView.init(frame: CGRect.init(x: left_x(object: self) + width(object: self) * CGFloat(index), y: top_y(object: self), width: width(object: self), height: height(object: self)))
            imageView.image = UIImage.init(imageLiteralResourceName: obj)
            imageView.tag = index
            scrollView?.addSubview(imageView)
        }
    }


    /** 初始化pageControl */
    @discardableResult
    fileprivate func initalPageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.frame = CGRect.init(x: 0.0, y: 0.0, width: SCREENWIDTH * 3.0/4.0, height: 50.0)
        pageControl.center = CGPoint.init(x: self.center.x, y: height(object: self) * (1.0 - 450.0/2400.0))
        pageControl.pageIndicatorTintColor = UIColor.red
        pageControl.currentPageIndicatorTintColor = UIColor.purple
        pageControl.addTarget(self, action: #selector(clickPageControl), for: .touchUpInside)
        self.addSubview(pageControl)
        return pageControl
    }


    //点击 pageControl 设置scrollView 偏移量
    @objc func clickPageControl() {
        let currentPage = pageControl?.currentPage
        UIView.animate(withDuration: 0.5) {
            self.scrollView?.contentOffset = CGPoint.init(x: SCREENWIDTH * CGFloat(currentPage!), y: (self.scrollView?.contentOffset.y)!)
        }
    }


    //UIScrollView Delegate
    @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsize: CGPoint = scrollView.contentOffset
        let currentPage = Int(offsize.x / width(object: self))
        pageControl?.currentPage = currentPage
    }

}
