//
//  AlbumsPresenterTests.swift
//  DeezerFunTests
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import XCTest
@testable import Deezer_Fun

fileprivate let loadingTracksExpectationDescription = "Loading Tracks Expectation"

class TracksPresenterTests: XCTestCase {

    var viewController: TracksViewControllerMock!
    fileprivate var apiClient: DeezerApiClient!
    fileprivate var httpClient: HttpClientMock!
    var presenter: TracksPresenter!
    var testBundle: Bundle!
    
    override func setUp() {
        testBundle = Bundle(for: type(of: self))
        httpClient = HttpClientMock(testBundle: testBundle)
        viewController = TracksViewControllerMock()
        apiClient = DeezerApiClient(httpClient: httpClient)
        let artist = Artist(id: 828, name: "Dream Theater", pictureSmall: URL(string: "https://cdns-images.dzcdn.net/images/artist/c7daf68cd427ff2d6317d59d39898cd2/56x56-000000-80-0-0.jpg")!)
        let album = Album(id: 0, title: "Scenes From a Memory", coverMedium: URL(string: "https://cdns-images.dzcdn.net/images/")!, coverBig: URL(string: "https://cdns-images.dzcdn.net/images/")!, releaseDate: Date())
        presenter = TracksPresenter(viewController: viewController, deezerApiClient: apiClient, artist: artist, album: album)
    }
    
    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssert(viewController.receivedTitle == "Scenes From a Memory", "Received title must be Scenes From a Memory")
        XCTAssert(viewController.startLoadingCalled, "Start loading must be called")
        XCTAssert(presenter.dataSource.tracks[0].count == 4, "Number of fetched albums must be 4")
        let loadingTracksExpectation = self.expectation(description: loadingTracksExpectationDescription)
        loadingTracksExpectation.expectedFulfillmentCount = 2
        viewController.expectations.append(loadingTracksExpectation)
        wait(for: [loadingTracksExpectation], timeout: 1)
        XCTAssert(viewController.refreshTableCalled, "Table must be refreshed with new data")
        XCTAssert(viewController.stopLoadingCalled, "Spinner must be stopped")
    }
    
    func testDisplayPlayer() {
        presenter.viewDidLoad()
        presenter.displayPlayerRequest(disk: 0, track: 1)
        XCTAssert(viewController.displayPlayerControllerCalled, "Method to display music player must be called")
        XCTAssert(viewController.receivedAlbumTitle == "Scenes From a Memory", "Must receive album Scenes From a Memory")
        XCTAssert(viewController.receivedTrackTitle == "Aerodynamic", "Must receive album Scenes From a Memory")
    }
}

fileprivate class HttpClientMock: HttpClient {
    let testBundle: Bundle
    init(testBundle: Bundle) { self.testBundle = testBundle }
    override func sendRequest(router: DeezerApiClient.Router, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        switch router {
        case .getTracks:
            let data = testBundle.dataFromFile("Tracks.json")
            completionHandler(data, nil, nil)
        default:
            break
        }
    }
}

class TracksViewControllerMock: TracksViewControllerProtocol {
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
        let expectation = expectations.first {$0.description == loadingTracksExpectationDescription}
        guard let foundExpectation = expectation else {
            return
        }
        stopLoadingCalled = true
        foundExpectation.fulfill()
    }
    
    var refreshTableCalled = false
    func refreshTable() {
        let expectation = expectations.first {$0.description == loadingTracksExpectationDescription}
        guard let foundExpectation = expectation else {
            return
        }
        refreshTableCalled = true
        foundExpectation.fulfill()
    }
    
    var displayPlayerControllerCalled = false
    var receivedAlbumTitle: String? = nil
    var receivedTrackTitle: String? = nil
    func displayPlayerController(album: Album, track: Track) {
        displayPlayerControllerCalled = true
        receivedAlbumTitle = album.title
        receivedTrackTitle = track.title
    }
}
