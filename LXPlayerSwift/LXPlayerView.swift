//
//  LXPlayerView.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/18.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit
import AVFoundation

class LXPlayerView: UIView {
    
    weak var transport : LXTransportProtocol?
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
        
    }
    
    init(player : AVPlayer){
        super.init(frame : CGRect.zero)
        self.backgroundColor = .black
        self.autoresizingMask = [.flexibleHeight ,.flexibleWidth]
        let layer = self.layer as! AVPlayerLayer
        layer.player = player
        
        print("")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
