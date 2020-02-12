//
//  DeezerApiClientAlbumsTests.swift
//  DeezerFunTests
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import XCTest
import Foundation
@testable import Deezer_Fun

class DeezerApiClientAlbumsTests: XCTestCase {
    
    var testBundle: Bundle!
    fileprivate var httpClient: HttpClientMock!
    var client: DeezerApiClient!
    
    override func setUp() {
        testBundle = Bundle(for: type(of: self))
        httpClient = HttpClientMock(testBundle: testBundle)
        client = DeezerApiClient(httpClient: httpClient)
    }
    
    func testSearchAlbums() {
        httpClient.errorSimulationType = .noError
        client.getAlbums(123) { result in
            if case let Result.success(albums) = result {
                XCTAssert(albums[3].title == "Stargazing - EP", "Title of fourth Album must be Stargazing - EP")
                return
            }
            XCTFail()
        }
    }
    
    func testSearchAlbumsWithDataNotReceivedError() {
        httpClient.errorSimulationType = .dataNotReceived
        client.getAlbums(123) { result in
            if case let Result.failure(error) = result {
                var validConditionMet = false
                if case DeezerApiError.dataNotReceived = error {
                    validConditionMet = true
                }
                XCTAssert(validConditionMet, "We must receive Data not received error")
                return
            }
            XCTFail()
        }
    }
    
    func testSearchAlbumsWithUrlSessionError() {
        httpClient.errorSimulationType = .urlSessionError
        client.getAlbums(123) { result in
            if case let Result.failure(error) = result {
                var validConditionMet = false
                if case DeezerApiError.urlSession = error {
                    validConditionMet = true
                }
                XCTAssert(validConditionMet, "We must receive URL Session error")
                return
            }
            XCTFail()
        }
    }
    
    func testSearchAlbumsWithDecodingError() {
        httpClient.errorSimulationType = .decodingError
        client.getAlbums(123) { result in
            if case let Result.failure(error) = result {
                var validConditionMet = false
                if case DeezerApiError.decoding = error {
                    validConditionMet = true
                }
                XCTAssert(validConditionMet, "We must receive Decoding missing error")
                return
            }
            XCTFail()
        }
    }
    
    func testSearchAlbumsWithDeezerNativeError() {
        httpClient.errorSimulationType = .deezerNativeError
        client.getAlbums(123) { result in
            if case let Result.failure(error) = result {
                XCTAssert(error.localizedDescription == "This is a Deezer Native Error", "We must receive a Deezer Native Error")
                return
            }
            XCTFail()
        }
    }
}

fileprivate class HttpClientMock: HttpClient {
    let testBundle: Bundle
    init(testBundle: Bundle) { self.testBundle = testBundle }
    
    enum ErrorSimulationType {
        case dataNotReceived
        case urlSessionError
        case decodingError
        case deezerNativeError
        case noError
    }
    var errorSimulationType: ErrorSimulationType!
    
    override func sendRequest(router: DeezerApiClient.Router, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        switch errorSimulationType {
        case .dataNotReceived:
            completionHandler(nil, nil, nil)
        case .urlSessionError:
            completionHandler(nil, nil, URLError.init(.badURL))
        default:
            let data: Data
            switch router {
            case .getAlbums:
                if errorSimulationType == .decodingError {
                    data = testBundle.dataFromFile("AlbumsBadlyFormatted.json")
                } else if errorSimulationType == .deezerNativeError {
                    data = testBundle.dataFromFile("DeezerNativeError.json")
                } else {
                    data = testBundle.dataFromFile("Albums.json")
                }
                completionHandler(data, nil, nil)
            default:
                break
            }
        }
    }
    
}
