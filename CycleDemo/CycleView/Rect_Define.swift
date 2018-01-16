//
//  Rect_Define.swift
//  QianMi
//
//  Created by lsh726 on 2018/1/12.
//  Copyright © 2018年 liusonghong. All rights reserved.
//

import Foundation
import UIKit


/**
 IPhoneX 5.8        屏幕分辨率为 1242 * 2800 竖屏点距  375.0 * 812.0 pt
 IPhone 8 plus  5.5 屏幕分辨率为 1080 * 1920 竖屏点距  414.0 * 736.0 pt
 IPhone 8 4.7       屏幕分辨率为 750 * 1334  竖屏点距  375.0 * 667.0 pt
 IPhone SE          屏幕分辨率为 640 * 1136  竖屏点距  320.0 * 568.0 pt
 IPhone 7 4.7       屏幕分辨率为 750 x 1334  竖屏点距  375.0 x 667.0 pt
 IPhone 7 plus 5.5  屏幕分辨率为 1080 x 1920 竖屏点距  414.0 * 736.0 pt
 IPhone 6s 4.7      屏幕分辨率为 750 x 1334  竖屏点距  375.0 x 667.0 pt
 IPhone 6s plus 5.5 屏幕分辨率为 1080 x 1920 竖屏点距  414.0 * 736.0 pt
 */

let SCREENWIDTH  = UIScreen.main.bounds.size.width
let SCREENHEIGHT = UIScreen.main.bounds.size.height
let SCALE_WIDTH  = UIScreen.main.bounds.size.width / 375.0
let SCALE_HEIGHT = UIScreen.main.bounds.size.width / 667.0 //先以 6的屏幕

let SPACENAME: String = (Bundle.main.infoDictionary?["CFBundleName"] as? String)!


func left_x(object: UIView) -> CGFloat {
    return object.frame.origin.x
}

func top_y(object: UIView) -> CGFloat {
    return object.frame.origin.y
}

func width(object: UIView) -> CGFloat {
    return object.frame.size.width
}

func height(object: UIView) -> CGFloat {
    return object.frame.size.height
}


let SDCycleImageH = SCREENHEIGHT / 3.0 - 70.0




