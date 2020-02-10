//
//  DeezerApiGetAlbums.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

struct DeezerApiGetAlbums: Codable {
    let albums: [DeezerApiAlbum]
    enum CodingKeys: String, CodingKey {
        case albums = "data"
    }
}
