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
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case coverMedium = "cover_medium"
    }
}
