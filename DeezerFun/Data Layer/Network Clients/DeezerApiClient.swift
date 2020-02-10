//
//  DeezerApiClient.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 9/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation



class DeezerApiClient {
    
    let errorHandler: ErrorHandler
    init(errorHandler: ErrorHandler = ErrorHandler()) {
        self.errorHandler = errorHandler
    }
    
    enum Router {
        case searchArtist(String)
        
        var method: HttpMethod {
            switch self {
            case .searchArtist:
                return .get
            }
        }
        
        var endPoint: URL {
            switch self {
            case .searchArtist(let artist):
                return URL(string: "https://api.deezer.com/search/artist?q=\(artist)")!
            }
        }
        
        var urlRequest: URLRequest {
            switch self {
            case .searchArtist:
                var request = URLRequest(url: endPoint)
                request.httpMethod = method.rawValue
                return request
            }
        }
    }
        
    func searchArtist(_ artist: String, completionHandler: @escaping (Result<[Artist], DeezerApiError>) -> Void) {
        URLSession.shared.dataTask(with: Router.searchArtist(artist).urlRequest) { (data, response, error) in
            guard self.errorHandler.validateResponse(data: data, error: error, completionHandler: completionHandler) else { return }
            do {
                let artistsDecodedResponse = try JSONDecoder().decode(DeezerApiSearchArtist.self, from: data!)
                let artists = artistsDecodedResponse.artists.map {Artist(id: $0.id, name: $0.name, pictureSmall: $0.pictureSmall)}
                completionHandler(Result.success(artists))
                return
            } catch let error {
                completionHandler(Result.failure(.decoding(error as! DecodingError)))
            }
        }.resume()
    }
}
