//
//  ViewController.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/17.
//  Copyright © 2018年 donglingxiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var controller : LXPlayerController?
    var isHidden : Bool = false
    var isStatusHidden : Bool {
        get{
            return false
        }
        set(hidden){
            isHidden = hidden
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    var dataSource : [VideoModel]?
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 70))
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    func setUpUI() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        tableView.register(LXVideoTableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setUpUI()
        getSIDArray()
        
//        let localURL = Bundle.main.url(forResource: "hubblecast", withExtension: "m4v")
//
//        controller  = LXPlayerController(url: localURL!)
//        let playerView  = controller?.view
//        playerView?.frame = self.view.frame
//        self.view.addSubview(playerView!)

    }
    func getSIDArray() {
        LXPlayerVideoRequest.getSIDArray(urlStr: "http://c.m.163.com/nc/video/home/0-10.html") { (sidArr, videoArr) in
//            print("回调\(sidArr)\(videoArr)")
            self.dataSource = videoArr
            self.tableView.reloadData()
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return isHidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((dataSource?.count) != nil) {
             return (dataSource?.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CELLID = "cellID"
        let cell : LXVideoTableViewCell = tableView.dequeueReusableCell(withIdentifier: CELLID) as! LXVideoTableViewCell
        if dataSource != nil {
            let model : VideoModel = (dataSource?[indexPath.row])!
            cell.titleLabel?.text = model.title
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
}


