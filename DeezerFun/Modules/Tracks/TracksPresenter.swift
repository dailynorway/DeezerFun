//
//  TracksPresenter.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

protocol TracksViewControllerProtocol: class {
    func startLoading()
    func stopLoading()
    func refreshTable()
    func setTitle(to title: String)
}

class TracksPresenter {
    unowned let viewController: TracksViewControllerProtocol
    let deezerApiClient: DeezerApiClient
    let artist: Artist
    let album: Album
    let dataSource: TracksDataSource
    
    init(viewController: TracksViewControllerProtocol,
         deezerApiClient: DeezerApiClient = DeezerApiClient(),
         artist: Artist,
         album: Album,
         dataSource: TracksDataSource = TracksDataSource()) {
        self.viewController = viewController
        self.deezerApiClient = deezerApiClient
        self.artist = artist
        self.album = album
        self.dataSource = dataSource
        self.dataSource.album = album
    }
    
    func viewDidLoad() {
        viewController.setTitle(to: album.title)
        fetchTracks()
    }
    
    // MARK: Private
    private func fetchTracks() {
        viewController.startLoading()
        deezerApiClient.getTracks(album.id) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.viewController.stopLoading()
            }
            switch result {
            case .success(let tracks):
                self?.dataSource.tracks = tracks
                DispatchQueue.main.async { [weak self] in
                    self?.viewController.refreshTable()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
