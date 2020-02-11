//
//  AlbumCell.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumReleaseYearLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    static let reuseIdentifier = "AlbumCell"
    private var task: URLSessionDataTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        task = nil
        albumImageView.image = nil
    }
    
    func configure(album: Album) {
        spinner.startAnimating()
        albumTitleLabel.text = album.title
        let releaseYear = album.releaseDate.toString(withDateFormat: "yyyy")
        albumReleaseYearLabel.text = "Release Year \(releaseYear)"
        if task == nil {
            task = albumImageView.downloadImage(from: album.coverMedium)
        }
    }
}
