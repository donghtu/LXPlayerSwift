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
    var currentIndexPath : IndexPath?
    var isSmall : Bool = true
    var isHidden : Bool = false
    var contentOffset : CGPoint?
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
extension ViewController : UITableViewDelegate,UITableViewDataSource,LXVideoCellDelegate,UIScrollViewDelegate {
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var currentOffset : CGPoint!
        if scrollView == self.tableView{
            currentOffset =  tableView.contentOffset
            currentOffset.y += SCREEN_HEIGHT/2
            let currentIndex : IndexPath = tableView.indexPathForRow(at: currentOffset) ?? IndexPath(row: 1111111, section: 1)
            if currentIndexPath == nil{
                return
            }
            let playerView : UIView = (controller?.playerView)!
            if playerView.superview != nil{
                let rectInTableView : CGRect = tableView.rectForRow(at: currentIndexPath!)
                let rectInSuperView : CGRect = tableView.convert(rectInTableView, to: tableView.superview)
                if (rectInSuperView.origin.y-64+(currentCell?.bounds.height)! < 0||rectInSuperView.origin.y > self.view.bounds.height){
                    if UIApplication.shared.keyWindow?.subviews.contains(playerView) == false && isSmall{
                        print("走了走了")
                        isSmall = false
                        toSmallScreen()
                    }
                }else {
                    if currentCell!.subviews.contains(playerView) == false && currentIndex == currentIndexPath && isSmall == false{
                        print("来了")
                        isSmall = true
                        toCell()
                    }
                }
            }
        }
    }
    func toSmallScreen() {
        print("小图")
        NotificationCenter.default.post(name: LXPlayerFullScreenNotification, object: false)
    }
    func toCell() {
        print("到cell了")
        if currentIndexPath != nil && currentCell != nil{
            let playerView  = controller?.view
            playerView!.removeFromSuperview()
            currentCell = tableView.cellForRow(at: currentIndexPath!) as? LXVideoTableViewCell
            if currentCell != nil {
                playerView!.frame = currentCell!.bounds
                
                currentCell!.addSubview(playerView!)
            }

        }
      
        
    }
    
    
    //MARK: - LXVideoCellDelegate
    func playVideos(button : UIButton) {
        contentOffset = tableView.contentOffset
        currentCell = tableView.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? LXVideoTableViewCell
        currentIndexPath = IndexPath(row: button.tag, section: 0)
        let model : VideoModel = dataSource[button.tag]
        if (controller != nil) {
            isSmall = true
            toCell()
            controller?.videoUrl = URL(string: model.mp4_url!)!
            
        }else{
            let videoUrl = URL(string: model.mp4_url!)
            controller  = LXPlayerController(url: videoUrl!,frame: (currentCell?.bounds)!)
            
            let playerView  = controller?.view
            currentCell!.addSubview(playerView!)
        }
        
        controller?.videoTitle = model.title
        
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
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell = tableView.cellForRow(at: indexPath) as? LXVideoTableViewCell
       cell?.coverView?.isHidden = true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    
}


