//
//  DeezerApiAlbum.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

struct DeezerApiAlbum: Codable {
    let id: Int
    let title: String
    let coverMedium: URL
    let releaseDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case coverMedium = "cover_medium"
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        coverMedium = try container.decode(URL.self, forKey: .coverMedium)
        let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
        releaseDate = releaseDateString.toDateWith(format: "yyyy-MM-dd")
    }
}
