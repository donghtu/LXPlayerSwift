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
    
    var asset : AVAsset!
    var playerItem : AVPlayerItem!
    var player : AVPlayer!
    var playerView : LXPlayerView!
    
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
        playerView.overlayView.delegate = self
        
    }

    deinit {
        self.playerItem.removeObserver(self, forKeyPath: self.STATUS_KEYPATH)
    }
}
extension LXPlayerController : LXTransportDelegate{



    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == STATUS_KEYPATH {
            DispatchQueue.main.async {
                if self.playerItem.status == AVPlayerItemStatus.readyToPlay {
                    let duration : CMTime = self.playerItem.duration
                    self.playerView.overlayView.setCurrentTime(time: CMTimeGetSeconds(kCMTimeZero), duration: CMTimeGetSeconds(duration))
                    self.addPlayerItemTimeObserver()
                    self.player.play()
                    self.loadMediaOptions()
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
        let callback = {[unowned self] (time :CMTime) -> Void  in
            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(self.playerItem.duration)
            self.playerView.overlayView.setCurrentTime(time: currentTime, duration: duration)
            }
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: callback)
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
    //MARK: - LXTransportDelegate
    func play(){
         print("点击确认按钮")
    }
    func pause(){

    }
    func stop(){

    }
    func scrubbingDidStart(){

    }
    func scrubbedToTime(time : TimeInterval){
        print("滑动视频")
        player.seek(to: CMTimeMakeWithSeconds(time, Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    func scrubbingDidEnd(){

    }
    func jumpedToTime(time : TimeInterval){

    }

}
