//
//  SearchPresenter.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol SearchViewControllerProtocol: class {
    func toggleEmptyStateImage()
    func refreshTable()
    func startLoading()
    func stopLoading()
    func navigateToAlbums(for artist: Artist)
}

class SearchPresenter {
    unowned let viewController: SearchViewControllerProtocol
    let deezerApiClient: DeezerApiClient
    let dataSource: SearchDataSource
    var timer: Timer?
    
    init(viewController: SearchViewControllerProtocol,
         deezerApiClient: DeezerApiClient = DeezerApiClient(),
         dataSource: SearchDataSource = SearchDataSource()) {
        self.viewController = viewController
        self.deezerApiClient = deezerApiClient
        self.dataSource = dataSource
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func viewDidLoad() {
        viewController.toggleEmptyStateImage()
    }
    
    // MARK: Requests
    func searchArtistRequest(with artistText: String) {
        if artistText.count < 3 {
            dataSource.artists = []
            viewController.toggleEmptyStateImage()
            viewController.refreshTable()
            return
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self?.viewController.startLoading()
            }
            self?.deezerApiClient.searchArtist(artistText) { [weak self] result in
                DispatchQueue.main.async { [weak self] in
                    self?.viewController.stopLoading()
                }
                switch result {
                case .success(let artists):
                    self?.dataSource.artists = artists
                    DispatchQueue.main.async { [weak self] in
                        self?.viewController.toggleEmptyStateImage()
                        self?.viewController.refreshTable()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
    }
    
    func selectArtistRequest(index: Int) {
        viewController.navigateToAlbums(for: dataSource.artists[index])
    }
}
