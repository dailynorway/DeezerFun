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
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SearchPresenter(viewController: self)
        presenter.viewDidLoad()
        prepareUiElements()
    }
    
    // MARK: Private
    private func prepareUiElements() {
        title = "Search Artists"
        tableView.dataSource = presenter.dataSource
        tableView.tableFooterView = UIView()
        searchController = UISearchController()
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.searchBar.searchTextField.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        searchController.searchBar.isTranslucent = true
        navigationItem.searchController = searchController
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}

// MARK: SearchViewControllerProtocol
extension SearchViewController: SearchViewControllerProtocol {
    func toggleEmptyStateImage() {
        if presenter.dataSource.artists.isEmpty {
            let imageView = UIImageView(image: UIImage(named: "empty_state"))
            imageView.contentMode = .center
            imageView.tintColor = .systemGray
            tableView.backgroundView = imageView
        } else {
            tableView.backgroundView = nil
        }
    }
    
    func refreshTable() {
        toggleEmptyStateImage()
        tableView.reloadData()
    }
    
    func startLoading() {
        searchController.searchBar.isLoading = true
    }
    
    func stopLoading() {
        searchController.searchBar.isLoading = false
    }
}

// MARK: UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        presenter.searchArtistRequest(with: textField.text ?? "")
    }
}
