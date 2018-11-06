//
//  VideoModel.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/11/6.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import HandyJSON

class VideoModel: HandyJSON {
    var cover: String?
    var descriptionDe: String?
    var length: Int?
    var m3u8_url: String?
    var m3u8Hd_url: String?
    var mp4_url: String?
    var mp4_Hd_url: String?
    var playCount: Int?
    var playersize: String?
    var ptime: String?
    var replyBoard: String?
    var replyCount: String?
    var replyid: String?
    var title: String?
    var vid: String?
    var videosource: String?
    
    required init() {}
}
class SidModel: HandyJSON {
     var imgsrc: String?
     var sid: String?
     var title: String?
    
    required init() {}
}
