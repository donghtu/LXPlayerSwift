//
//  ViewController.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/17.
//  Copyright © 2018年 donglingxiao. All rights reserved.
//

import UIKit
import MJRefresh

class ViewController: UIViewController {

    var controller : LXPlayerController?
    var currentCell : LXVideoTableViewCell?
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
    var dataSource =  [VideoModel]()
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
        
        setUpUI()
        setupRefresh()
        getSIDArray()
    }
    @objc func getSIDArray() {
        let url = String("http://c.m.163.com/nc/video/home/\(dataSource.count - dataSource.count%10)-10.html")
        LXPlayerVideoRequest.getSIDArray(urlStr: url) {[unowned self]  (sidArr, videoArr) in
//            print("回调\(sidArr)\(videoArr)")
            
            self.dataSource.append(contentsOf: videoArr)
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
        }
    }
    func setupRefresh() {

        let footer = MJRefreshAutoNormalFooter()
        footer.stateLabel.textColor = .black
        footer.setRefreshingTarget(self, refreshingAction: #selector(getSIDArray))
        footer.setTitle("上拉刷新", for: .idle)
        footer.setTitle("释放更新", for: .pulling)
        footer.setTitle("正在刷新...", for: .refreshing)
        self.tableView.mj_footer = footer
    }
    override var prefersStatusBarHidden: Bool{
        return isHidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController : UITableViewDelegate,UITableViewDataSource,LXVideoCellDelegate {
    

    func playVideos(button : UIButton) {
        currentCell = tableView.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? LXVideoTableViewCell
        let model : VideoModel = dataSource[button.tag]
        if (controller != nil) {
            print("controller exist")
            let playerView  = controller?.view
            playerView?.removeFromSuperview()
            controller?.videoUrl = URL(string: model.mp4_url!)!
            
        }else{
//            let localURL = Bundle.main.url(forResource: "hubblecast", withExtension: "m4v")
            
            let videoUrl = URL(string: model.mp4_url!)
            controller  = LXPlayerController(url: videoUrl!,frame: (currentCell?.bounds)!)
//            let playerView  = controller?.view
//            currentCell!.addSubview(playerView!)
        }
        let playerView  = controller?.view
        currentCell!.addSubview(playerView!)
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count > 0 {
            return dataSource.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CELLID = "cellID"
        let cell : LXVideoTableViewCell = tableView.dequeueReusableCell(withIdentifier: CELLID) as! LXVideoTableViewCell
        if dataSource.count > 0 {
            let model : VideoModel = dataSource[indexPath.row]
            cell.videoModel = model
            cell.playButton?.tag = indexPath.row
            cell.delegate = self
//            cell.titleLabel?.text = model.title
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
}


