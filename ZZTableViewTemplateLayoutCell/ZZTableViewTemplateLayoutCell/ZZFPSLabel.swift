//
//  ZZFPSLabel.swift
//  LearnYY
//
//  Created by duzhe on 16/3/9.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit
private let kSize = CGSizeMake(55, 20)
class ZZFPSLabel: UILabel {
    var _link:CADisplayLink!
    var _count:Int = 0
    var _lastTime:NSTimeInterval = 0
    var _font:UIFont!
    var _subFont:UIFont!
    
    var _llll:NSTimeInterval!
    
    override init(var frame: CGRect) {
        if frame.size.width == 0 && frame.size.height == 0{
            frame.size = kSize
        }
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textAlignment = NSTextAlignment.Center
        self.userInteractionEnabled = false
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        _font = UIFont(name: "Menlo", size: 14)
        if _font != nil{
            _subFont = UIFont(name: "Menlo", size: 14)
        }else{
            _font = UIFont(name: "Courier", size: 14)
            _subFont = UIFont(name: "Courier", size: 14)
        }
        
        _link = CADisplayLink(target: self, selector: "tick:")
        _link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }

    @objc private func tick(link:CADisplayLink){
        
        if _lastTime == 0{
            _lastTime = link.timestamp
            return
        }
        _count++
        let delta = link.timestamp - _lastTime
        if delta < 1{
            return
        }
        _lastTime = link.timestamp
        let fps = Double(_count)/delta
        
        _count = 0
        let progress:CGFloat = CGFloat(fps)/60.0
        let color = UIColor(hue: 0.27 * (progress - 0.2) , saturation: 1, brightness: 0.9, alpha: 1 )
        let text = NSMutableAttributedString(string: "\(Int(round(fps))) FPS")
        text.setColor(color, range: NSMakeRange(0 , text.length - 3))
        text.setColor(UIColor.whiteColor(), range:  NSMakeRange( text.length - 3 ,3))
        text.setFount(_font, range: NSMakeRange(0, text.length))
        text.setFount(_subFont, range: NSMakeRange(text.length-4, 1))
        
        self.attributedText = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return kSize
    }
    
    deinit{
        _link.invalidate()
    }
}

extension NSMutableAttributedString{
    
    func setFount(font:UIFont,range:NSRange){
        self.setAttribute(NSFontAttributeName, value: font, range: range)
    }
    
    
    func setColor(color:UIColor,range:NSRange){
        self.setAttribute(kCTForegroundColorAttributeName as String , value: color.CGColor, range:range)
        self.setAttribute(NSForegroundColorAttributeName, value: color, range: range)
    }
    
    func setAttribute(name:String?,value:AnyObject?,range:NSRange){
        guard let name = name else{ return }
        guard let value = value else{
            self.removeAttribute(name, range: range)
            return
        }
        self.addAttribute(name, value: value, range: range)
    }
    
}