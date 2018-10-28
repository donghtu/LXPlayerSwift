//
//  LXThumbnail.swift
//  LXPlayerSwift
//
//  Created by 董凌晓 on 2018/10/27.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit
import CoreMedia

class LXThumbnail: NSObject {

    var time : CMTime
    var image : UIImage
    
    init(image : UIImage, time : CMTime) {
        self.time = time
        self.image = image
    }
}
