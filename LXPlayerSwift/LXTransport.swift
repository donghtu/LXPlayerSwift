//
//  LXTransport.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/18.
//  Copyright © 2018年 donglingxiao. All rights reserved.
//

import Foundation

@objc protocol LXTransportDelegate {
    func play()
    func pause()
    func stop()
    func scrubbingDidStart()
    func scrubbedToTime(time : TimeInterval)
    func scrubbingDidEnd()
    func jumpedToTime(time : TimeInterval)
    
    @objc optional func subtitleSelected(subtitle : String)
}
@objc protocol LXTransportProtocol  {
    
//    weak var delegate : LXTransportDelegate?{get set}
    func playbackComplete()
    
    func setTitle(title : String)
    func setCurrentTime(time : TimeInterval,  duration : TimeInterval)
    func setScrubbingTime(time : TimeInterval)
    func setSubtitles(subtitles : [String])
}


