//
//  TracksViewController.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import UIKit
import AVKit

class TracksViewController: UITableViewController, Storyboarded {

    var presenter: TracksPresenter!
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        prepareUiElements()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let header = tableView.tableHeaderView else { return }
        header.frame.size.height = UIScreen.main.bounds.width
    }
    
    // MARK: Private
    private func prepareUiElements() {
        setHeaderImage()
        prepareTableView()
        addActivityIndicatorView()
        
    }
    
    private func prepareTableView() {
        tableView.dataSource = presenter.dataSource
        tableView.estimatedRowHeight = 53
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: TrackHeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: TrackHeaderView.reuseIdentifier)
    }
    
    private func setHeaderImage() {
        var imageSet = false
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        let _ = imageView.downloadImage(from: presenter.album.coverBig) { [weak self] _ in
            imageSet = true
            self?.tableView.tableHeaderView = imageView
        }
        if !imageSet {
            let spinner = UIActivityIndicatorView()
            spinner.startAnimating()
            tableView.tableHeaderView = spinner
        }
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
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TrackHeaderView.reuseIdentifier) as? TrackHeaderView else {
            fatalError("Could not dequeue table section header, this should never happen!")
        }
        headerView.volumeLabel.text = "Volume \(section + 1)"
        return headerView
    }
    
    }
}

extension TracksViewController: TracksViewControllerProtocol {
    func startLoading() { activityIndicator.isHidden = false }
    func stopLoading() { activityIndicator.isHidden = true }
    func refreshTable() { tableView.reloadData() }
    func setTitle(to title: String) { self.title = title }
    
}
