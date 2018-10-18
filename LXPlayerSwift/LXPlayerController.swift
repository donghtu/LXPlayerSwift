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
    var PlayerItemStatusContext : String!
    var view : UIView?
    var asset : AVAsset!
    var playerItem : AVPlayerItem!
    var player : AVPlayer!
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
        playerItem.addObserver(self, forKeyPath: STATUS_KEYPATH, options: [.new, .old, .initial], context: &PlayerItemStatusContext)
        player = AVPlayer(playerItem: playerItem)
        
        
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &PlayerItemStatusContext {
            DispatchQueue.main.async {
                self.playerItem.removeObserver(self, forKeyPath: self.STATUS_KEYPATH)
            }
        }
    }
}
