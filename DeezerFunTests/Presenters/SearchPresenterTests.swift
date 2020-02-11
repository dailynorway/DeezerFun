//
//  SearchPresenterTests.swift
//  DeezerFunTests
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import XCTest
@testable import DeezerFun

let expectationForApiClientDescription = "Expectation Search has started on API Client"

class SearchPresenterTests: XCTestCase {

    var viewController: SearchViewControllerMock!
    var apiClient: DeezerApiClientMock!
    var presenter: SearchPresenter!
    var testBundle: Bundle!
    
    override func setUp() {
        testBundle = Bundle(for: type(of: self))
        viewController = SearchViewControllerMock()
        apiClient = DeezerApiClientMock()
        presenter = SearchPresenter(viewController: viewController, deezerApiClient: apiClient)
    }
    
    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssert(viewController.toggleEmptyStateImageCalled, "As soon as the controller load we need to display empty state")
    }
    
    func testSearchRequestWithLessThan3Characters() {
        presenter.searchArtistRequest(with: "Er")
        XCTAssert(viewController.toggleEmptyStateImageCalled, "There will be no search until we have more then 3 characters")
        XCTAssert(apiClient.searchArtistEndpointCalled == false, "No network request must be made until we have more than 3 characters")
        XCTAssert(viewController.startLoadingCalled == false, "The loading spinner will not be displayed")
        XCTAssert(viewController.refreshTableCalled, "Table View Must be refreshed to hide results")
    }
    
    func testSearchRequestWith3CharactersMinimum() {
        presenter.searchArtistRequest(with: "Eric")
        let expectationForApiClient = self.expectation(description: expectationForApiClientDescription)
        apiClient.expectations.append(expectationForApiClient)
        wait(for: [expectationForApiClient], timeout: 1)
        XCTAssert(apiClient.searchArtistEndpointCalled, "No network request must be made until we have more than 3 characters")
    }
    
    func testNavigationToSelectedArtist() {
        let decodedArtistData = testBundle.decode(DeezerApiSearchArtist.self, from: "Artists.json")
        let artists = decodedArtistData.artists.map {Artist(id: $0.id, name: $0.name, pictureSmall: $0.pictureSmall)}
        presenter.dataSource.artists = artists
        presenter.selectArtistRequest(index: 0)
        XCTAssert(viewController.navigateToAlbumsCalled, "It must call navigate to Album")
        XCTAssert(viewController.artistName == "Kygo", "Selected artist's name must be Kygo")
    }
}

class DeezerApiClientMock: DeezerApiClient {
    var expectations = [XCTestExpectation]()
    
    var searchArtistEndpointCalled = false
    override func searchArtist(_ artist: String, completionHandler: @escaping (Result<[Artist], DeezerApiError>) -> Void) {
        let expectation = expectations.first {$0.description == expectationForApiClientDescription}
        guard let foundExpectation = expectation else {
            return
        }
        searchArtistEndpointCalled = true
        foundExpectation.fulfill()
    }
}

class SearchViewControllerMock: SearchViewControllerProtocol {
    var toggleEmptyStateImageCalled = false
    func toggleEmptyStateImage() {
        toggleEmptyStateImageCalled = true
    }
    
    var refreshTableCalled = false
    func refreshTable() {
        refreshTableCalled = true
    }
    
    var startLoadingCalled = false
    func startLoading() {
        startLoadingCalled = true
    }
    
    func stopLoading() {}
    
    var navigateToAlbumsCalled = false
    var artistName: String? = nil
    func navigateToAlbums(for artist: Artist) {
        navigateToAlbumsCalled = true
        artistName = artist.name
    }
}
