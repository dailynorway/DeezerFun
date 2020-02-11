//
//  DeezerApiClient.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 9/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

class DeezerApiClient {
    
    let httpClient: HttpClient
    let errorHandler: ErrorHandler
    
    init(httpClient: HttpClient = HttpClient(), errorHandler: ErrorHandler = ErrorHandler()) {
        self.httpClient = httpClient
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
                let encodedArtist = artist.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
                return URL(string: "https://api.deezer.com/search/artist?q=\(encodedArtist!)")!
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
        httpClient.sendRequest(router: Router.searchArtist(artist)) { (data, response, error) in
            guard self.errorHandler.validateResponse(data: data, error: error, completionHandler: completionHandler) else { return }
            do {
                let artistsDecodedResponse = try JSONDecoder().decode(DeezerApiSearchArtist.self, from: data!)
                let artists = artistsDecodedResponse.artists.map {Artist(id: $0.id, name: $0.name, pictureSmall: $0.pictureSmall)}
                completionHandler(Result.success(artists))
                return
            } catch let error {
                completionHandler(Result.failure(.decoding(error as! DecodingError)))
            }
        }
    }
    
    func getAlbums(_ artistId: Int, completionHandler: @escaping (Result<[Album], DeezerApiError>) -> Void) {
        httpClient.sendRequest(router: Router.getAlbums(artistId)) { (data, response, error) in
            guard self.errorHandler.validateResponse(data: data, error: error, completionHandler: completionHandler) else { return }
            do {
                let albumsDecodedResponse = try JSONDecoder().decode(DeezerApiGetAlbums.self, from: data!)
                var albums = albumsDecodedResponse.albums.map {Album(id: $0.id, title: $0.title, coverMedium: $0.coverMedium, coverBig: $0.coverBig, releaseDate: $0.releaseDate)}
                albums.sort {$0.releaseDate > $1.releaseDate}
                completionHandler(Result.success(albums))
                return
            } catch let error {
                completionHandler(Result.failure(.decoding(error as! DecodingError)))
            }
        }
    }
    
    func getTracks(_ albumId: Int, completionHandler: @escaping (Result<[[Track]], DeezerApiError>) -> Void) {
        httpClient.sendRequest(router: Router.getTracks(albumId)) { (data, response, error) in
            guard self.errorHandler.validateResponse(data: data, error: error, completionHandler: completionHandler) else { return }
            do {
                let tracksDecodedResponse = try JSONDecoder().decode(DeezerApiGetTracks.self, from: data!)
                let tracks = tracksDecodedResponse.tracks.map {Track(id: $0.id, title: $0.title, shortTitle: $0.shortTitle, position: $0.position, duration: $0.duration, preview: $0.preview, disk: $0.disk)}

                var volumedTracks: [[Track]] = []
                let max = tracks.map { $0.disk }.max()
                guard max != nil else { return }
                for disk in 1...max! {
                    volumedTracks.append(tracks.filter {$0.disk == disk})
                }
                completionHandler(Result.success(volumedTracks))
                return
            } catch let error {
                completionHandler(Result.failure(.decoding(error as! DecodingError)))
            }
        }
    }
}
