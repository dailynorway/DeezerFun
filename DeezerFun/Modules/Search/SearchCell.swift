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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    static let reuseIdentifier = "SearchCell"
    private var task: URLSessionDataTask?

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        task = nil
        artistImageView.image = nil
    }
    
    func configure(artist: Artist) {
        spinner.startAnimating()
        artistName.text = artist.name
        if task == nil {
            task = artistImageView.downloadImage(from: artist.pictureSmall)
        }
    }
}
