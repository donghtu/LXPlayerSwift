//
//  LXVideoTableViewCell.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/11/6.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol LXVideoCellDelegate : class {
    func playVideos(button : UIButton)
}

class LXVideoTableViewCell: UITableViewCell {

    var coverView : UIImageView?
    var titleLabel : UILabel?
    var playButton : UIButton?
    var bottomView : UIView?
    weak var delegate : LXVideoCellDelegate?
    
    var videoModel = VideoModel(){
        didSet {
            titleLabel?.text = videoModel.title
            let url = URL(string: videoModel.cover!)
            coverView?.kf.setImage(with: url)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
   
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.coverView = UIImageView()
        self.contentView.addSubview(self.coverView!)
        
        self.titleLabel = UILabel()
        self.titleLabel?.backgroundColor = .clear
        self.titleLabel?.textColor = .white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        self.contentView.addSubview(self.titleLabel!)
        
        self.playButton = UIButton(type: .custom)
        self.playButton?.setBackgroundImage(UIImage(named: "play"), for: .normal)
        self.playButton?.addTarget(self, action: #selector(playVideo(button:)), for: .touchUpInside)
        self.contentView.addSubview(self.playButton!)
        
        self.bottomView = UIView()
        self.bottomView?.backgroundColor = .white
        self.contentView.addSubview(self.bottomView!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpUI()
    }
    func setUpUI() {

        self.coverView?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(self.contentView.snp.top)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-20)
        })
        
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView.snp.top).offset(5)
            make.height.equalTo(25)
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
        })
        
        self.playButton?.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.bottomView?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.contentView.snp.bottom)
            make.height.equalTo(20)
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
        })
    }
    @objc func playVideo(button : UIButton){
        self.delegate?.playVideos(button: button)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
