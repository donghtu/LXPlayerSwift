//
//  LXVideoTableViewCell.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/11/6.
//  Copyright © 2018 donglingxiao. All rights reserved.
//

import UIKit
import SnapKit

class LXVideoTableViewCell: UITableViewCell {

    var coverView : UIImageView?
    var titleLabel : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
   
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        self.coverView = UIImageView()
        self.contentView.addSubview(self.coverView!)
        
        self.titleLabel = UILabel()
        self.titleLabel?.backgroundColor = .clear
        self.titleLabel?.textColor = .black
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        self.contentView.addSubview(self.titleLabel!)
        
        self.coverView?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(self.contentView.snp.top)
            make.bottom.equalTo(self.contentView.snp.bottom)
        })
        
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView.snp.top).offset(5)
            make.height.equalTo(self.contentView.bounds.height)
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
        })
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
