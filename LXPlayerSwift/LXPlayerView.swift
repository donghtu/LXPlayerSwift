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
    
//    weak var transport : LXTransportProtocol?{
//        get{
//            return self.overlayView
//        }
//    }
//    weak var delegate : LXTransportDelegate?
//    var overlayView : LXOverlayView!
//    var overlayView : LXOverlayView! = (Bundle.main.loadNibNamed("LXOverlayView", owner: nil, options: nil)?.last as! LXOverlayView)
    lazy var overlayView : LXOverlayView! = {
        let overlayView  = Bundle.main.loadNibNamed("LXOverlayView", owner: nil, options: nil)?.last as! LXOverlayView
        overlayView.backgroundColor = UIColor.init(white: 1, alpha: 1)
        return overlayView
    }()
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
        
    }
    
    init(player : AVPlayer){
        super.init(frame : CGRect.zero)
        self.backgroundColor = .black
        self.autoresizingMask = [.flexibleHeight ,.flexibleWidth]
        let layer = self.layer as! AVPlayerLayer
        layer.player = player
        overlayView?.backgroundColor = UIColor.init(white: 1, alpha: 0)
        self.addSubview(overlayView!)
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(gestureRecog)
        UIView.animate(withDuration: 3.0) {
            self.overlayView.alpha = 0.0

        }
    }
    
    @objc func tapAction() {
        print("tap +++")
        UIView.animate(withDuration: 3.0, animations: {
            
        }, completion: { (iscomplete) in
            self.overlayView.alpha = 1.0
            if iscomplete {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                     self.overlayView.alpha = 0.0
                })
            }
        })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView?.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
