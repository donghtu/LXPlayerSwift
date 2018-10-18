//
//  ViewController.swift
//  LXPlayerSwift
//
//  Created by donglingxiao on 2018/10/17.
//  Copyright © 2018年 donglingxiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let localURL = Bundle.main.url(forResource: "hubblecast", withExtension: "m4v")
        
        let controller : LXPlayerController = LXPlayerController(url: localURL!)
        let playerView  = controller.view
        playerView.frame = self.view.frame
        self.view.addSubview(playerView )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

