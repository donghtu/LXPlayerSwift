//
//  LXPlayerVideoRequest.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/11/5.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit
import Alamofire

class LXPlayerVideoRequest: NSObject {
    
    class func getSIDArray(urlStr : String,completion : @escaping (_ sidArr : [SidModel], _ videoArr : [VideoModel]) -> Void){
        let url = URL(string: urlStr)
    var sidArr = [SidModel]()
    var videoArr = [VideoModel]()
        DispatchQueue.global(qos: .default).async {
            
            Alamofire.request(url!).responseJSON(completionHandler: { (response) in
                print("视频数据\(String(describing: response.value))")
                let dic = response.value as! Dictionary<String, Any>
                let video :[Dictionary<String,Any>] = dic["videoList"] as! [Dictionary<String,Any>]
                for index in video {
                    let model = VideoModel.deserialize(from: index)
                    videoArr.append(model!)
                    print("可能\(String(describing: model?.cover))")
                }
                let sid : [Dictionary<String,Any>] = dic["videoSidList"] as![Dictionary<String,Any>]
                for index in sid {
                    let model = SidModel.deserialize(from: index)
                    sidArr.append(model!)
                    print("可能\(String(describing: model?.title))")
                }
                completion(sidArr,videoArr)
            })
//            Alamofire.request(url!).responseJSON(queue: <#T##DispatchQueue?#>, options: .mutableLeaves, completionHandler: <#T##(DataResponse<Any>) -> Void#>)
        }
        
    }
}
