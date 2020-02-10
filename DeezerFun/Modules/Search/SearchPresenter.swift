//
//  SearchPresenter.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol SearchViewControllerProtocol: class {
    func displayEmptyStateImage()
}

class SearchPresenter {
    unowned let viewController: SearchViewControllerProtocol
    let deezerApiClient: DeezerApiClient
    let dataSource: SearchDataSource
    
    init(viewController: SearchViewControllerProtocol,
         deezerApiClient: DeezerApiClient = DeezerApiClient(),
         dataSource: SearchDataSource = SearchDataSource()) {
        self.viewController = viewController
        self.deezerApiClient = deezerApiClient
        self.dataSource = dataSource
    }
    
    func viewDidLoad() {
        if dataSource.artists.isEmpty {
            viewController.displayEmptyStateImage()
        }
    }
}
