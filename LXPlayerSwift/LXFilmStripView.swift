//
//  LXFilmStripView.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/29.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit
import CoreMedia

class LXFilmStripView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    var thumbnails = [LXThumbnail]()
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(buildScubber(notification:)), name: LXThumbnailsGeneratedNotification, object: nil)
    }
    @objc func buildScubber(notification : NSNotification) {
        self.thumbnails = notification.object as! [LXThumbnail]
        var currentX : CGFloat = 0.0
        let size = self.thumbnails.first?.image.size
        let imageSize = __CGSizeApplyAffineTransform(size!, CGAffineTransform.init(scaleX: 0.5, y: 0.5))
        let imageRect = CGRect.init(x: currentX, y: 0.0 as CGFloat, width: imageSize.width, height: imageSize.height)

        let imageWidth = imageRect.width * CGFloat(self.thumbnails.count)
        self.scrollView.contentSize = CGSize.init(width: imageWidth, height: imageRect.size.height)
        
        for index in 0...(self.thumbnails.count - 1 ){
            let timedImage = self.thumbnails[index]
            let button = UIButton(type: .custom)
            button.adjustsImageWhenHighlighted = false
            button.setBackgroundImage(timedImage.image, for: .normal)
            button.frame = CGRect(x: currentX, y: 0 as CGFloat, width: imageSize.width, height: imageSize.height)
            button.tag = index
            button.addTarget(self, action: #selector(imageButtonTapped(sender:)), for: .touchUpInside)
            self.scrollView.addSubview(button)
            currentX += imageSize.width
            
        }
        
    }
    @objc func imageButtonTapped(sender : UIButton) {
        let image = self.thumbnails[sender.tag]
        if (self.superview?.isKind(of: LXOverlayView.self))!
        {
            let superView : LXOverlayView = self.superview as! LXOverlayView
            superView.setCurrentTime(time: Double(CMTimeGetSeconds(image.time)) )
            
        }
    }
}
