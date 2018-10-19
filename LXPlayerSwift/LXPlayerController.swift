//
//  LXPlayerController.swift
//  LXAVPlayerSwift
//
//  Created by donglingxiao on 2018/10/17.
//  Copyright © 2018年 donglingxiao. All rights reserved.
//

import UIKit
import AVFoundation

class LXPlayerController: NSObject ,LXTransportDelegate{
    let STATUS_KEYPATH = "status"

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
//        _ = playerView.overlayView
        playerView.overlayView.delegate = self
//        transport = playerView.overlayView
//        transport!.delegate = self
//        transport?.playbackComplete()
    }

    func play(){
        
    }
    func pause(){
        
    }
    func stop(){
        
    }
    func scrubbingDidStart(){
        
    }
    func scrubbedToTime(time : TimeInterval){
        print("滑动视频")
        //        player.seek(to: CMTimeMakeWithSeconds(time, Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    func scrubbingDidEnd(){
        
    }
    func jumpedToTime(time : TimeInterval){
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//            if keyPath == STATUS_KEYPATH {
//                DispatchQueue.main.async {
    //                if self.playerItem.status == AVPlayerItemStatus.readyToPlay {
    //                    self.player.play()
    //                }else {
    //                    print("出错了")
    //                }
                    print("资源状态改变")
//                }
//            }
        }
    deinit {
        self.playerItem.removeObserver(self, forKeyPath: self.STATUS_KEYPATH)
    }
}
//extension LXPlayerController {
//
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
////        if keyPath == STATUS_KEYPATH {
////            DispatchQueue.main.async {
//////                if self.playerItem.status == AVPlayerItemStatus.readyToPlay {
//////                    self.player.play()
//////                }else {
//////                    print("出错了")
//////                }
////                print("资源状态改变")
////            }
////        }
//    }
//
////    func play(){
////
////    }
////    func pause(){
////
////    }
////    func stop(){
////
////    }
////    func scrubbingDidStart(){
////
////    }
////    func scrubbedToTime(time : TimeInterval){
////        print("滑动视频")
//////        player.seek(to: CMTimeMakeWithSeconds(time, Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
////    }
////    func scrubbingDidEnd(){
////
////    }
////    func jumpedToTime(time : TimeInterval){
////
////    }
//
//}
