//
//  TrackHeaderView.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import UIKit

class TrackHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var volumeLabel: UILabel!

    static let reuseIdentifier = "TrackHeaderView"
}
