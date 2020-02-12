//
//  DeezerApiSearchArtist.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 9/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

struct DeezerApiSearchArtist: Codable {
    let artists: [DeezerApiArtist]
    enum CodingKeys: String, CodingKey {
        case artists = "data"
    }
}
