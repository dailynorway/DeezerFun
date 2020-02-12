//
//  TrackCell.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    static let reuseIdentifier = "TrackCell"
    
    func configure(track: Track, album: Album) {
        positionLabel.text = "\(track.position)."
        titleLabel.text = track.shortTitle.uppercased()
        albumTitleLabel.text = album.title
        
        let hours = track.duration / 3600
        let minutes = track.duration / 60 % 60
        let seconds = track.duration % 60
        if hours > 0 {
           durationLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            durationLabel.text = String(format: hours > 0 ? "%02i:%02i:%02i" : "%02i:%02i", minutes, seconds)
        }
    }
}
