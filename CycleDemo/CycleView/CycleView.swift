//
//  CycleView.swift
//  QianMi
//
//  Created by lsh726 on 2018/1/16.
//  Copyright © 2018年 liusonghong. All rights reserved.
//

import UIKit
//import Kingfisher

/**  数据源里面图片假设是 A B C D 四张图片
     scrollView 需要用 4 + 2 张图片才能"偷天换日"
     D A B C D A ， 当scrollView 偏移量到最后一张A 时候，此时需要默默人把scrollView.contentOffset是设置成第二章A的位置，造成无限轮播的假象。
     反之同理,当 scrollView 偏移量到第一张D 时， 此时需要默默人把scrollView.contentOffset是设置成倒数第二章D的位置！
 */

//cell 里面的view
class CycleView: CycleSuperView {
    var timerInterval: TimeInterval?
    var timer: Timer?
    var ClickCurrentView: ((String) -> Void)? //点击事件回调
    var dataCount: Int? //数据源个数 - 1
    var cycleDataArray: Array<String>? {//初始化赋值
        didSet {
            dataCount = (self.cycleDataArray?.count)! - 1
            scrollView?.contentSize = CGSize.init(width: CGFloat((dataCount!) + 3) * width(object: self), height: height(object: self))
            pageControl?.numberOfPages = (dataCount!) + 1
            pageControl?.sizeThatFits(CGSize.init(width: 100, height: 25))
            pageControl?.isUserInteractionEnabled = false//禁止，否则逻辑太麻烦
            initialImageView()//初始化背景图片
            self.scrollView?.setContentOffset(CGPoint.init(x: SCREENWIDTH * 1.0, y: (self.scrollView?.contentOffset.y)!), animated: false)

            instanceTimer()//定时器循环
        }
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
    }


    convenience init(frame: CGRect, _ timerInterval: TimeInterval? = 3.0) {
        self.init(frame: frame)
        self.timerInterval = timerInterval
    }


    override func initialImageView() {
        //数据源前后各增加一个站位图片
        var tempArray: Array<String>? = cycleDataArray
        let cycFirst = cycleDataArray![self.dataCount!]
        let cycLast = cycleDataArray![0]
        tempArray?.insert(cycFirst, at: 0)
        tempArray?.append(cycLast)
        for (index, obj) in (tempArray?.enumerated())! {
            let imageView = UIImageView.init(frame: CGRect.init(x: left_x(object: self) + width(object: self) * CGFloat(index), y: top_y(object: self), width: width(object: self), height: height(object: self)))
//            let url: URL? = URL.init(string: obj.picUrl!)
            //这里直接用本地图片代替了
            imageView.image = UIImage.init(imageLiteralResourceName: obj)
//            imageView.contentMode = .scaleAspect
//            if url != nil {
//                imageView.kf.setImage(with: url, placeholder: UIImage.init(imageLiteralResourceName: "page1"), options: [KingfisherOptionsInfoItem.forceRefresh], progressBlock: nil, completionHandler: nil)
//            }
            imageView.tag = index
            scrollView?.addSubview(imageView)
        }
    }


    //获取当前的index
    func getCurrentIndex() -> Int {
        let offsize: CGPoint = (self.scrollView?.contentOffset)!
        let currentPage = Int(offsize.x / width(object: self))
        return currentPage
    }


    //增加点击事件
    func addTapGesture(_ ClickAction: @escaping (String)-> Void) {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(ClickView))
        self.addGestureRecognizer(tapGesture)
        ClickCurrentView = ClickAction
    }


    @objc func ClickView() {
        let str: String? = self.cycleDataArray?[(self.pageControl?.currentPage)!]
        if self.ClickCurrentView != nil {
            self.ClickCurrentView!(str!)
        }
    }


    //创建定时器
    private func instanceTimer()  {
        guard self.timer != nil else {
            self.timer = Timer.init(timeInterval: self.timerInterval!, target: self, selector: #selector(cycleImageView), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: .commonModes)
            return
        }
    }


    //停止计时器
    func stopTimer() {
        self.timer?.fireDate = Date.distantFuture
    }


    //开启定时器
    func startTimer() {
        self.timer?.fireDate = Date.init(timeInterval: 3.0, since: Date())
    }


    @objc func cycleImageView() {
        let index = getCurrentIndex()
        timerCutCycleView(index)
    }


    //定时器处理切换图片
    func timerCutCycleView(_ currentPage: Int) {
        cutAnimation(currentPage + 1)//设置动画位移，肯定是在当前的位移 + 1
    }


    //切换动画
    func cutAnimation(_ offsetIndex: Int) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowAnimatedContent, animations: {
            self.scrollView?.setContentOffset(CGPoint.init(x: SCREENWIDTH * CGFloat(offsetIndex), y: (self.scrollView?.contentOffset.y)!), animated: false)
        }) { (flag) in
            guard flag else { return }
            if offsetIndex - 1 >= self.dataCount! + 1 {//障眼法，偷偷替换ContentOffset位置
                self.scrollView?.setContentOffset(CGPoint.init(x: SCREENWIDTH * CGFloat(1), y: (self.scrollView?.contentOffset.y)!), animated: false)
            }

            let index = self.getCurrentIndex()
            self.cutPageControl(index - 1)//pageControl 显示的和当scrollovew偏移量 - 1关系
        }
    }


    //切换pageControl的index
    func cutPageControl(_ index: Int)  {
        self.pageControl?.currentPage = index
    }


    //UIScrollView Delegate
    @objc override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startTimer()
        let index = getCurrentIndex()
        if index > self.dataCount! + 1 {
            self.cutPageControl(0)//“偷天换日，不太清楚概念的请仔细阅读类头部的解释”
            self.scrollView?.setContentOffset(CGPoint.init(x: SCREENWIDTH * CGFloat(1), y: (self.scrollView?.contentOffset.y)!), animated: false)
        } else if index == 0 {//“偷天换日，不太清楚概念的请仔细阅读类头部的解释”
            self.cutPageControl(self.dataCount!)
            self.scrollView?.setContentOffset(CGPoint.init(x: SCREENWIDTH * CGFloat(self.dataCount! + 1), y: (self.scrollView?.contentOffset.y)!), animated: false)
        } else {
            cutPageControl(index - 1)
        }
    }


    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }


    deinit {
        self.timer?.invalidate()
        if self.timer != nil {
            self.timer = nil
        }
    }

}
