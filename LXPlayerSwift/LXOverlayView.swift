//
//  LXOverlayView.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/19.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit

class LXOverlayView: UIView ,LXTransportProtocol{

    
   
    @IBOutlet weak var slider: UISlider!
    weak var delegate: LXTransportDelegate?
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        delegate?.play()
    }
    @IBAction func showButtonClicked(_ sender: Any) {
        delegate?.play()
    }
    @IBAction func showPopupUI(_ sender: UISlider) {


    }
    @IBAction func hidePopupUI(_ sender: UISlider) {
//        setScrubbingTime(time: TimeInterval(sender.value))
        print("kkkkk")
        delegate?.scrubbedToTime(time: TimeInterval(sender.value))

    }
    @IBAction func unhidePopupUI(_ sender: UISlider) {

    }
    
    
    
    
    func playbackComplete() {
       self.slider.value = 0
        print("The end")
    }


    func setTitle(title : String){

    }
    func setCurrentTime(time : TimeInterval,  duration : TimeInterval){
        self.slider.minimumValue = 0.0
        self.slider.maximumValue = Float(duration)
        self.slider.value = Float(time)
        
    }
    func setScrubbingTime(time : TimeInterval){

    }
    func setSubtitles(subtitles : [String]){

    }
}
