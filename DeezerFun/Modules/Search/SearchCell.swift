//
//  SearchCell.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    
    static let reuseIdentifier = "SearchCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(artist: Artist) {
        artistName.text = artist.name
    }
}
