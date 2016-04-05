//
//  ZZFeedEntity.swift
//  ZZTableViewTemplateLayoutCell
//
//  Created by duzhe on 16/4/5.
//  Copyright © 2016年 dz. All rights reserved.
//

import Foundation

class ZZFeedEntity{
    
    var title:String
    var content:String
    var username:String
    var time:String
    var imageName:String
    
    init(dic:NSDictionary){
        self.title = dic["title"] as? String ?? ""
        self.content = dic["content"] as? String ?? ""
        self.username = dic["username"] as? String ?? ""
        self.time = dic["time"] as? String ?? ""
        self.imageName = dic["imageName"] as? String ?? ""
    }
    
}