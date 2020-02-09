//
//  DeezerApiArtist.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 9/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

struct DeezerApiArtist: Codable {
    let id: Int
    let name: String
    let pictureSmall: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pictureSmall = "picture_small"
    }
}
