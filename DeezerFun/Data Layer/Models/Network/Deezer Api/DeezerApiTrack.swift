//
//  DeezerApiTrack.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

struct DeezerApiTrack: Codable {
    let id: Int
    let title: String
    let shortTitle: String
    let position: Int
    let duration: Int
    let preview: URL
    let disk: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case shortTitle = "title_short"
        case position = "track_position"
        case duration
        case preview
        case disk = "disk_number"
    }
}
