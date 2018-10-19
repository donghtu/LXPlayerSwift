//
//  LXPlayerView.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/18.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit
import AVFoundation

class LXPlayerView: UIView, LXTransportDelegate {
    
//    weak var transport : LXTransportProtocol?{
//        get{
//            return self.overlayView
//        }
//    }
    weak var delegate : LXTransportDelegate?
    var overlayView : LXOverlayView! = (Bundle.main.loadNibNamed("LXOverlayView", owner: nil, options: nil)?.last as! LXOverlayView)
//    lazy var overlayView : LXOverlayView! = {
//        let over  = Bundle.main.loadNibNamed("LXOverlayView", owner: nil, options: nil)?.last
////        overlayView = over as? LXOverlayView
////        over.backgroundColor = UIColor.init(white: 1, alpha: 0)
//
//        return over as? LXOverlayView
//    }()
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
        
    }
    
    init(player : AVPlayer){
        super.init(frame : CGRect.zero)
        self.backgroundColor = .black
        self.autoresizingMask = [.flexibleHeight ,.flexibleWidth]
        let layer = self.layer as! AVPlayerLayer
        layer.player = player
        
//        overlayView = (Bundle.main.loadNibNamed("LXOverlayView", owner: nil, options: nil)?.last as! LXOverlayView)
        overlayView?.backgroundColor = UIColor.init(white: 1, alpha: 0)
        
        self.addSubview(overlayView!)
//        overlayView.delegate = delegate
        print("")
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
    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView?.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
