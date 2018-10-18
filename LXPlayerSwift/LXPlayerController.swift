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
//    var PlayerItemStatusContext : UnsafeMutablePointer<Any>
    
//    var PlayerItemStatusContext : UnsafeMutableRawPointer =
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
    
}
extension LXPlayerController {
    
    private func prepareToPlay() {
        let keys :[String] = [ "tracks",
                               "duration",
                               "commonMetadata",
                               "availableMediaCharacteristicsWithMediaSelectionOptions"]
        playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: keys)
        playerItem.addObserver(self, forKeyPath: STATUS_KEYPATH, options: [.new, .old, .initial], context: nil)
        player = AVPlayer(playerItem: playerItem)
        playerView = LXPlayerView(player: player)
        
        
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == STATUS_KEYPATH {
            DispatchQueue.main.async {
                self.playerItem.removeObserver(self, forKeyPath: self.STATUS_KEYPATH)
                if self.playerItem.status == AVPlayerItemStatus.readyToPlay {
                    self.player.play()
                }else {
                    print("出错了")
                }
            }
        }
    }
}
