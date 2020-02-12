//
//  AlbumsPresenterTests.swift
//  DeezerFunTests
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import XCTest
@testable import Deezer_Fun

fileprivate let loadingAlbumsExpectationDescription = "Loading Albums Expectation"
fileprivate let errorDisplayedExpectationDescription = "Error Displayed Expectation"

class AlbumsPresenterTests: XCTestCase {

    var viewController: AlbumsViewControllerMock!
    fileprivate var apiClient: DeezerApiClientMock!
    var presenter: AlbumsPresenter!
    var testBundle: Bundle!
    
    override func setUp() {
        testBundle = Bundle(for: type(of: self))
        viewController = AlbumsViewControllerMock()
        apiClient = DeezerApiClientMock(testBundle: testBundle)
        let artist = Artist(id: 828, name: "Dream Theater", pictureSmall: URL(string: "https://cdns-images.dzcdn.net/images/artist/c7daf68cd427ff2d6317d59d39898cd2/56x56-000000-80-0-0.jpg")!)
        presenter = AlbumsPresenter(viewController: viewController, deezerApiClient: apiClient, artist: artist)
    }
    
    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssert(viewController.receivedTitle == "Dream Theater", "Received title must be Dream Theater")
        XCTAssert(viewController.startLoadingCalled, "Start loading must be called")
        XCTAssert(presenter.dataSource.albums.count == 4, "Number of fetched albums must be 4")
        let loadingAlbumsExpectation = self.expectation(description: loadingAlbumsExpectationDescription)
        loadingAlbumsExpectation.expectedFulfillmentCount = 2
        viewController.expectations.append(loadingAlbumsExpectation)
        wait(for: [loadingAlbumsExpectation], timeout: 1)
        XCTAssert(viewController.stopLoadingCalled, "Spinner must stop after data is retrieved")
        XCTAssert(viewController.refreshCollectionCalled, "Collection View must be refreshed after data is retrieved")
    }
    
    func testAlbumSelection() {
        presenter.viewDidLoad()
        presenter.selectAlbumRequest(index: 1)
        XCTAssert(viewController.navigateToAlbumCalled, "It must initiate navigation to album")
        XCTAssert(viewController.receivedAlbumId == 56534782, "It must receive albumd with id 56534782")
    }
    
    func testNavigationToTracks() {
        presenter.viewDidLoad()
        presenter.selectAlbumRequest(index: 0)
        XCTAssert(viewController.navigateToAlbumCalled)
    }
    
    func testFailToFetchData() {
        apiClient.shouldFailRequest = true
        presenter.viewDidLoad()
        let errorDisplayedExpectation = self.expectation(description: errorDisplayedExpectationDescription)
        viewController.expectations.append(errorDisplayedExpectation)
        wait(for: [errorDisplayedExpectation], timeout: 1)
        XCTAssert(viewController.displayErrorMessageCalled, "An error message must be displayed when network request fails")
    }
}

fileprivate class DeezerApiClientMock: DeezerApiClient {
    let testBundle: Bundle
    var shouldFailRequest = false
    init(testBundle: Bundle) { self.testBundle = testBundle }
    
    override func getAlbums(_ artistId: Int, completionHandler: @escaping (Result<[Album], DeezerApiError>) -> Void) {
        if shouldFailRequest {
            completionHandler(Result.failure(.dataNotReceived))
        } else {
            let decodedAlbumsData = testBundle.decode(DeezerApiGetAlbums.self, from: "Albums.json")
            let albums = decodedAlbumsData.albums.map {Album(id: $0.id, title: $0.title, coverMedium: $0.coverMedium, coverBig: $0.coverBig, releaseDate: $0.releaseDate)}
            completionHandler(Result.success(albums))
        }
    }
}

class AlbumsViewControllerMock: AlbumsViewControllerProtocol {
    var expectations = [XCTestExpectation]()
    
    var receivedTitle: String? = nil
    func setTitle(to title: String) {
        receivedTitle = title
    }
    
    var startLoadingCalled = false
    func startLoading() {
        startLoadingCalled = true
    }
    
    var stopLoadingCalled = false
    func stopLoading() {
        let expectation = expectations.first {$0.description == loadingAlbumsExpectationDescription}
        guard let foundExpectation = expectation else {
            return
        }
        stopLoadingCalled = true
        foundExpectation.fulfill()
    }
    
    var refreshCollectionCalled = false
    func refreshCollection() {
        let expectation = expectations.first {$0.description == loadingAlbumsExpectationDescription}
        guard let foundExpectation = expectation else {
            return
        }
        refreshCollectionCalled = true
        foundExpectation.fulfill()
    }
    
    var navigateToAlbumCalled = false
    var receivedAlbumId: Int? = nil
    func navigateToAlbum(album: Album) {
        navigateToAlbumCalled = true
        receivedAlbumId = album.id
    }
    
    var displayErrorMessageCalled = false
    func displayErrorMessage(_ message: String) {
        let expectation = expectations.first {$0.description == errorDisplayedExpectationDescription}
        guard let foundExpectation = expectation else {
            return
        }
        displayErrorMessageCalled = true
        foundExpectation.fulfill()
    }
}
