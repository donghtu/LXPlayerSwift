//
//  LXOverlayView.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/19.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit
import CoreMedia

class LXOverlayView: UIView ,LXTransportProtocol{

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    
    @IBOutlet weak var showButton: UIButton!
    

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var filmStripView: LXFilmStripView!
    @IBOutlet weak var slider: UISlider!
    weak var delegate: LXTransportDelegate?
    var filmStripHidden = true
    @IBAction func doneButtonClicked(_ sender: Any) {
        delegate?.stop()
    }
    @IBAction func showButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.35, animations: {
            self.filmStripView.isHidden = false
            var frame = self.filmStripView.frame
            frame.origin.y = 0
            self.filmStripView.frame = frame
        }) { (complete) in
            self.filmStripView.isHidden = false;
        }
        self.showButton.isSelected = !self.showButton.isSelected
    }
    @IBAction func playButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if (self.delegate != nil) {
            if sender.isSelected {
                self.delegate?.play()
            }else {
                self.delegate?.pause()
            }
        }
    }
    @IBAction func showPopupUI(_ sender: UISlider) {
        self.currentTimeLabel.text = "-- : --"
        self.restTimeLabel.text = "-- : --"
        delegate?.scrubbedToTime(time: TimeInterval(sender.value))
    }
    @IBAction func hidePopupUI(_ sender: UISlider) {
//        setScrubbingTime(time: TimeInterval(sender.value))
        print("touch up inside")
        delegate?.scrubbingDidEnd()

    }
    @IBAction func unhidePopupUI(_ sender: UISlider) {
        print("touch down")
        delegate?.scrubbingDidStart()
    }
    
    @IBAction func fullscreen(_ sender: UIButton) {
        print("点击屏幕按钮")
        sender.isSelected = !sender.isSelected
        NotificationCenter.default.post(name: LXPlayerFullScreenNotification, object: sender.isSelected)
        
    }
    
    
    
    func playbackComplete() {
       self.slider.value = 0
        print("The end")
    }


    func setTitle(title : String){

    }
    func setCurrentTime(time : TimeInterval,  duration : TimeInterval){
        if duration.isNaN{
            print("NANNANNANNAN")
            self.currentTimeLabel.text = "--"
            self.restTimeLabel.text = "--"
        }else {
            
            self.slider.maximumValue = Float(duration)
            self.slider.minimumValue = 0.0
            self.slider.value = Float(time)
            let currentTime : Int = Int(ceil(time))
            let restTime = Int(duration - time)
            self.currentTimeLabel.text = formatSeconds(value: currentTime)
            self.restTimeLabel.text = formatSeconds(value: restTime)
        }
        
    }
    func setScrubbingTime(time : TimeInterval){

    }
    func setSubtitles(subtitles : [String]){

    }
    func setCurrentTime(time : TimeInterval){
        delegate?.jumpedToTime(time: time)
    }
    
    func formatSeconds(value : Int) -> String {
        let seconds = value % 60
        let minutes = value / 60
        return String(format: "%02d:%02d", minutes,seconds)
    }
}
