//
//  LXPlayerView.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/18.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit
import AVFoundation

enum LXCoverCategory {
    case normal
    case filmStrip
}
class LXPlayerView: UIView {
    
    lazy var overlayView : LXOverlayView! = {
        let overlayView : LXOverlayView!
        switch coverCategory! {
        case .filmStrip:
            overlayView  = Bundle.main.loadNibNamed("LXOverlayView", owner: nil, options: nil)?.last as? LXOverlayView
            overlayView.backgroundColor = UIColor.init(white: 1, alpha: 1)
        default:
            overlayView  = Bundle.main.loadNibNamed("LXOverlayNormalView", owner: nil, options: nil)?.last as! LXOverlayNormalView
            overlayView.backgroundColor = UIColor.init(white: 1, alpha: 1)
        }
        
        return overlayView
    }()
    var coverHidden : Bool? {
        willSet(newValue){
            if newValue == true {
                self.overlayView.alpha = 0.0
                
                if self.coverCategory == .filmStrip {
                    self.overlayView.showButton.isSelected = false
                    self.overlayView.filmStripView.isHidden = true
                }
            }
        }
    }
    var videoTitle : String?{
        willSet(newValue){
            if self.coverCategory == .normal {
                print("视频标题\(String(describing: newValue))")
                self.overlayView.titleLabel.text = newValue
            }
        }
    }
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
        
    }
    var coverCategory : LXCoverCategory!
    init(player : AVPlayer ,frame: CGRect,category:LXCoverCategory) {
        
        super.init(frame : frame)
        self.backgroundColor = .black
        self.autoresizingMask = [.flexibleHeight ,.flexibleWidth]
        coverCategory = category
        let layer = self.layer as! AVPlayerLayer
        layer.player = player
        self.overlayView?.backgroundColor = UIColor.init(white: 1, alpha: 0)
        self.addSubview(self.overlayView!)
        NotificationCenter.default.addObserver(self, selector: #selector(fullScreenNotification(notify:)), name: LXPlayerFullScreenNotification, object: nil)
        
        UIView.animate(withDuration: 3.0) {
            self.overlayView.alpha = 0.0

        }
    }
    
    @objc func fullScreenNotification(notify : NSNotification) {
        let isSelect : Bool = notify.object as! Bool
        var next : UIResponder?
        next = self.next
        while next?.isKind(of: ViewController.self) == false {
            next = next?.next
        }
        if next != nil {
            if (next?.isKind(of: ViewController.self))!{
                let ne = (next as! ViewController)
                ne.isStatusHidden = isSelect
            }
        }
        if isSelect {

            toFullScreen(orientation: .landscapeLeft)
        }else{
            
            toSmallScreen()
        }
    }

    func toFullScreen(orientation : UIInterfaceOrientation) {
        self.removeFromSuperview()
        self.transform = .identity
        if orientation == .landscapeLeft {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }else if orientation == .landscapeRight{
            self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    func toSmallScreen() {
        self.removeFromSuperview()
        self.transform = .identity
        self.frame = CGRect(x: SCREEN_WIDTH, y: (SCREEN_HEIGHT - (SCREEN_WIDTH/2))/2, width: SCREEN_WIDTH, height: (SCREEN_WIDTH/2))
        UIApplication.shared.keyWindow?.addSubview(self)
        UIApplication.shared.keyWindow?.bringSubview(toFront: self)
        UIView.animate(withDuration: 0.5) {
            var rect = self.frame as CGRect
            rect.origin.x = SCREEN_WIDTH/3
            rect.size.width = SCREEN_WIDTH*2/3
            self.frame = rect
        }
    }
    @objc func toCell(notify : NSNotification) {
        print("滚回到实际cell")
        let cell = notify.object as! UIView
        self.removeFromSuperview()
        self.frame = cell.bounds
        cell.addSubview(self)
        cell.bringSubview(toFront: self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView?.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
