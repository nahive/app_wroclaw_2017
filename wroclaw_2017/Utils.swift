//
//  Utils.swift
//  wroclaw_2017
//
//  Created by nahive on 29/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import Foundation

class Utils {
    
    class func colorize (hex: Int, alpha: Double = 1.0) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        var color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        return color
    }
    
    class func arrayShuffle<T>(var list: Array<T>) -> Array<T> {
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
    
    class func fadeIn(view: UIView, duration: Double? = 0.5, delay: Double? = 0.0){
        UIView.animateWithDuration(duration!,
            delay: delay!,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                view.alpha = 1.0
            },
            completion: { finished in
                
        })
    }
    
    class func fadeOut(view: UIView, duration: Double? = 0.5, delay: Double? = 0.0){
        UIView.animateWithDuration(duration!,
            delay: delay!,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                view.alpha = 0.0
            },
            completion: { finished in
                
        })
    }

}