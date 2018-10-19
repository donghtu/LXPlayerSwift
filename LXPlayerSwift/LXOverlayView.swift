//
//  LXOverlayView.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/19.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit

class LXOverlayView: UIView {

    weak var delegate: LXTransportDelegate?
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
    }
    @IBAction func showButtonClicked(_ sender: Any) {
        
    }
    @IBAction func showPopupUI(_ sender: UISlider) {
//        setScrubbingTime(time: TimeInterval(sender.value))
        delegate?.scrubbedToTime(time: TimeInterval(sender.value))

    }
    @IBAction func hidePopupUI(_ sender: UISlider) {
//        setScrubbingTime(time: TimeInterval(sender.value))
        print("kkkkk")
        delegate?.scrubbedToTime(time: TimeInterval(sender.value))

    }
    @IBAction func unhidePopupUI(_ sender: UISlider) {
//        setScrubbingTime(time: TimeInterval(sender.value))
        delegate?.scrubbedToTime(time: TimeInterval(sender.value))
    }
    
    
    
    
    func playbackComplete() {

    }


    func setTitle(title : String){

    }
    func setCurrentTime(time : TimeInterval,  duration : TimeInterval){

    }
    func setScrubbingTime(time : TimeInterval){

    }
    func setSubtitles(subtitles : [String]){

    }
}
