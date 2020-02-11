//
//  AlbumsViewController.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import UIKit

class AlbumsViewController: UICollectionViewController, Storyboarded {

    var presenter: AlbumsPresenter!
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUiElements()
        presenter.viewDidLoad()
    }
    
    // MARK: Private
    private func prepareUiElements() {
        prepareCollectionView()
        addActivityIndicatorView()
    }
    
    private func prepareCollectionView() {
        collectionView.dataSource = presenter.dataSource
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width/2 - 5, height: width/2 + 45)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 5
        collectionView!.collectionViewLayout = layout
    }
    
    private func addActivityIndicatorView() {
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemGray
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        view.addConstraint(verticalConstraint)
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectAlbumRequest(index: indexPath.item)
    }
}

extension AlbumsViewController: AlbumsViewControllerProtocol {
    func setTitle(to title: String) { self.title = title }
    func startLoading() { activityIndicator.isHidden = false }
    func stopLoading() { activityIndicator.isHidden = true }
    func refreshCollection() { collectionView.reloadData() }
    
    func navigateToAlbum(album: Album) {
        let vc = TracksViewController.instantiate()
        vc.presenter = TracksPresenter(viewController: vc, artist: presenter.artist, album: album)
        navigationController?.pushViewController(vc, animated: true)
    }
}
