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
        case getAlbums(Int)
        case getTracks(Int)
        
        var method: HttpMethod {
            switch self {
            case .searchArtist, .getAlbums, .getTracks:
                return .get
            }
        }
        
        var endPoint: URL {
            switch self {
            case .searchArtist(let artist):
                return URL(string: "https://api.deezer.com/search/artist?q=\(artist)")!
            case .getAlbums(let artistId):
                return URL(string: "https://api.deezer.com/artist/\(artistId)/albums")!
            case .getTracks(let albumId):
                return URL(string: "https://api.deezer.com/album/\(albumId)/tracks")!
            }
        }
        
        var urlRequest: URLRequest {
            switch self {
            case .searchArtist, .getAlbums, .getTracks:
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
    
    func getAlbums(_ artistId: Int, completionHandler: @escaping (Result<[Album], DeezerApiError>) -> Void) {
        URLSession.shared.dataTask(with: Router.getAlbums(artistId).urlRequest) { (data, response, error) in
            guard self.errorHandler.validateResponse(data: data, error: error, completionHandler: completionHandler) else { return }
            do {
                let albumsDecodedResponse = try JSONDecoder().decode(DeezerApiGetAlbums.self, from: data!)
                let albums = albumsDecodedResponse.albums.map {Album(id: $0.id, title: $0.title, coverMedium: $0.coverMedium)}
                completionHandler(Result.success(albums))
                return
            } catch let error {
                completionHandler(Result.failure(.decoding(error as! DecodingError)))
            }
        }.resume()
    }
    
    func getTracks(_ albumId: Int, completionHandler: @escaping (Result<[Track], DeezerApiError>) -> Void) {
        URLSession.shared.dataTask(with: Router.getTracks(albumId).urlRequest) { (data, response, error) in
            guard self.errorHandler.validateResponse(data: data, error: error, completionHandler: completionHandler) else { return }
            do {
                let tracksDecodedResponse = try JSONDecoder().decode(DeezerApiGetTracks.self, from: data!)
                let tracks = tracksDecodedResponse.tracks.map {Track(id: $0.id, title: $0.title, shortTitle: $0.shortTitle, position: $0.position, duration: $0.duration, preview: $0.preview)}
                completionHandler(Result.success(tracks))
                return
            } catch let error {
                completionHandler(Result.failure(.decoding(error as! DecodingError)))
            }
        }.resume()
    }
}
