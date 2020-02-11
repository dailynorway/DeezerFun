//
//  AlbumsPresenter.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol AlbumsViewControllerProtocol: class {
    func setTitle(to title: String)
    func startLoading()
    func stopLoading()
    func refreshCollection()
    func navigateToAlbum(id: Int)
}

class AlbumsPresenter {
    unowned let viewController: AlbumsViewControllerProtocol
    let deezerApiClient: DeezerApiClient
    let artist: Artist
    let dataSource: AlbumsDataSource
    
    init(viewController: AlbumsViewControllerProtocol,
         deezerApiClient: DeezerApiClient = DeezerApiClient(),
         artist: Artist,
         dataSource: AlbumsDataSource = AlbumsDataSource()) {
        self.viewController = viewController
        self.deezerApiClient = deezerApiClient
        self.artist = artist
        self.dataSource = dataSource
    }
    
    func viewDidLoad() {
        fetchAlbums(artistId: artist.id)
        viewController.setTitle(to: artist.name)
    }
    
    // MARK: Requests
    func selectAlbumRequest(index: Int) {
        viewController.navigateToAlbum(id: dataSource.albums[index].id)
    }
    
    // MARK: Private
    private func fetchAlbums(artistId: Int) {
        viewController.startLoading()
        deezerApiClient.getAlbums(artistId) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.viewController.stopLoading()
            }
            switch result {
            case .success(let albums):
                self?.dataSource.albums = albums
                DispatchQueue.main.async { [weak self] in
                    self?.viewController.refreshCollection()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
