//
//  LXPlayerController.swift
//  LXAVPlayerSwift
//
//  Created by donglingxiao on 2018/10/17.
//  Copyright © 2018年 donglingxiao. All rights reserved.
//

import UIKit
import AVFoundation

class LXPlayerController: NSObject {
    let STATUS_KEYPATH = "status"
    
    let REFRESH_INTERVAL = 0.5
    var view : UIView{
        get{
            return playerView
        }
    }
    var delayAnimation = false
    var lastPlaybackRate : Float?
    var asset : AVAsset!
    var playerItem : AVPlayerItem!
    var player : AVPlayer!
    var playerView : LXPlayerView!
    var timeObserver : AnyObject?
    var itemEndObserver : AnyObject?
    var imageGenerator  : AVAssetImageGenerator?
    weak var transport : LXTransportProtocol?
    
    init(url :URL){
        super.init()
        asset = AVAsset(url: url)
        prepareToPlay()
    }
    private func prepareToPlay() {
        let keys :[String] = [ "tracks",
                               "duration",
                               "commonMetadata",
                               "availableMediaCharacteristicsWithMediaSelectionOptions"]
        playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: keys)
        playerItem.addObserver(self, forKeyPath: STATUS_KEYPATH, options: [.new, .old, .initial], context: nil)
        player = AVPlayer(playerItem: playerItem)
        playerView = LXPlayerView(player: player)
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        playerView.addGestureRecognizer(gestureRecog)
        self.transport = playerView.overlayView
        self.transport?.delegate = self
        
    }

    deinit {
        self.playerItem.removeObserver(self, forKeyPath: self.STATUS_KEYPATH)
        if (self.itemEndObserver != nil) {
            let nc = NotificationCenter.default
            nc.removeObserver(self.itemEndObserver!, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        }
    
    }
}
extension LXPlayerController : LXTransportDelegate{



    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == STATUS_KEYPATH {
            DispatchQueue.main.async {
                if self.playerItem.status == AVPlayerItemStatus.readyToPlay {
                    let duration : CMTime = self.playerItem.duration
                    self.transport?.setCurrentTime(time: CMTimeGetSeconds(kCMTimeZero), duration: CMTimeGetSeconds(duration))
                    self.addPlayerItemTimeObserver()
                    self.addItemEndObserverForPlayerItem()
                    //self.player.play()
                    self.loadMediaOptions()
                    self.generateThumbnails()
                    print("播放")
                }else {
                    print("出错了")
                }
                print("资源状态改变")
            }
        }
    }
    
    func addPlayerItemTimeObserver() {
        let interval = CMTimeMakeWithSeconds(REFRESH_INTERVAL, Int32(NSEC_PER_SEC))
        let callback = {[unowned self] (time : CMTime) -> Void  in
            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(self.playerItem.duration)
            self.transport?.setCurrentTime(time: currentTime, duration: duration)
            }
        self.timeObserver = self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: callback) as AnyObject
    }
    func addItemEndObserverForPlayerItem() {
        let name = Notification.Name.AVPlayerItemDidPlayToEndTime;
        let callback = {[unowned self] (note : Notification) -> Void in
            self.player.seek(to: kCMTimeZero, completionHandler: { (finished) in
                self.transport?.playbackComplete()
            })
        }
        self.itemEndObserver = NotificationCenter.default.addObserver(forName: name, object: self.playerItem, queue: OperationQueue.main, using: callback);
        
        
        
    }
    func loadMediaOptions() {
        let mc = AVMediaCharacteristic.legible
        let group = self.asset.mediaSelectionGroup(forMediaCharacteristic: mc)
        if (group != nil) {
            var subtitles = [String]()
            for option : AVMediaSelectionOption in (group?.options)!
            {
                subtitles.append(option.displayName)
            }
            print("媒体信息\(subtitles)")
        }
    }
    func generateThumbnails (){
        self.imageGenerator = AVAssetImageGenerator(asset: self.asset)
        self.imageGenerator?.maximumSize = CGSize(width: 200, height: 0.0)
        let duration = self.asset.duration
        var times = [NSValue]()
        let increment = duration.value / 20
        var currentValue = 2 * Int64(duration.timescale)
        while currentValue <= Int64(duration.value) {
             let time = CMTimeMake(currentValue, duration.timescale)
             times.append(NSValue(time: time))
             currentValue += increment
        }
        var imageCount = times.count
        var images = [LXThumbnail]()
        
        self.imageGenerator?.generateCGImagesAsynchronously(forTimes: times, completionHandler: { (requestTime, imageRef, actualTime, result, error) in
            if result == AVAssetImageGeneratorResult.succeeded {
                let image = UIImage(cgImage: imageRef!)
                
                let thumbnail = LXThumbnail.init(image: image, time: actualTime)
                images.append(thumbnail)
                
            }else {
                print("Error: \(error!.localizedDescription)")
            }
            imageCount -= 1
            if (imageCount == 0) {
                DispatchQueue.main.async {
                    let name = LXThumbnailsGeneratedNotification
                    NotificationCenter.default.post(name: name, object: images)
                }
            }
        })
    }
        
    //MARK: - LXTransportDelegate
    func play(){
        self.player.play()
    }
    func pause(){
        self.lastPlaybackRate = self.player.rate
        self.player.pause()
    }
    func stop(){
        self.player.rate = 0.0
        self.player.pause()
    }
    func scrubbingDidStart(){
        self.delayAnimation = true
        self.lastPlaybackRate = self.player.rate
        self.player.removeTimeObserver(self.timeObserver!)
        self.timeObserver = nil
    }
    func scrubbedToTime(time : TimeInterval){
        playerItem.cancelPendingSeeks()
        player.seek(to: CMTimeMakeWithSeconds(time, Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    func scrubbingDidEnd(){
        self.delayAnimation = false
        self.delayAnimationAction()
        addPlayerItemTimeObserver()
        if self.lastPlaybackRate! > Float(0.0) {
            self.player.play()
        }
    }
    func jumpedToTime(time : TimeInterval){
        player.seek(to: CMTimeMakeWithSeconds(time, Int32(NSEC_PER_SEC)))
    }
    @objc func tapAction() {
        UIView.animate(withDuration: 3.0, animations: {

        }, completion: { (iscomplete) in
            self.playerView.overlayView.alpha = 1.0
            if iscomplete {
                self.delayAnimationAction()
            }
        })
    }
    func delayAnimationAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            if(!self.delayAnimation && self.playerView.overlayView.alpha != 0.0){
                self.playerView.overlayView.alpha = 0.0
                self.playerView.overlayView.filmStripView.isHidden = true
                self.playerView.overlayView.showButton.isSelected = false
            }
            
        })
    }
}
