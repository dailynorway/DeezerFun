//
//  SearchViewController.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    var presenter: SearchPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SearchPresenter(viewController: self)
        presenter.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

extension SearchViewController: SearchViewControllerProtocol {
    func displayEmptyStateImage() {
        tableView.backgroundView = UIImageView(image: UIImage(named: "empty_state"))
    }
}
