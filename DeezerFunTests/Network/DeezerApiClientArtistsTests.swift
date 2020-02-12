//
//  DeezerApiClientArtistTests.swift
//  DeezerFunTests
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import XCTest
@testable import Deezer_Fun

class DeezerApiClientArtistTests: XCTestCase {

    var testBundle: Bundle!
    fileprivate var httpClient: HttpClientMock!
    var client: DeezerApiClient!
    
    override func setUp() {
        testBundle = Bundle(for: type(of: self))
        httpClient = HttpClientMock(testBundle: testBundle)
        client = DeezerApiClient(httpClient: httpClient)
    }

    func testSearchArtist() {
        httpClient.errorSimulationType = .noError
        client.searchArtist("Kygo") { result in
            if case let Result.success(artists) = result {
                XCTAssert(artists[1].name == "Kygo & Justin Jesso", "Name of first artist return must be Kygo")
                return
            }
            XCTFail()
        }
    }
    
    func testSearchArtistWithDataNotReceivedError() {
        httpClient.errorSimulationType = .dataNotReceived
        client.searchArtist("Kygo") { result in
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
    
    func testSearchArtistWithUrlSessionError() {
        httpClient.errorSimulationType = .urlSessionError
        client.searchArtist("Kygo") { result in
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
    
    func testSearchArtistWithDecodingError() {
        httpClient.errorSimulationType = .decodingError
        client.searchArtist("Kygo") { result in
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
    
    func testSearchArtistWithDeezerNativeError() {
        httpClient.errorSimulationType = .deezerNativeError
        client.searchArtist("Kygo") { result in
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
            case .searchArtist:
                if errorSimulationType == .decodingError {
                    data = testBundle.dataFromFile("ArtistsBadlyFormatted.json")
                } else if errorSimulationType == .deezerNativeError {
                    data = testBundle.dataFromFile("DeezerNativeError.json")
                } else {
                    data = testBundle.dataFromFile("Artists.json")
                }
                completionHandler(data, nil, nil)
            default:
                break
            }
        }
    }
}
