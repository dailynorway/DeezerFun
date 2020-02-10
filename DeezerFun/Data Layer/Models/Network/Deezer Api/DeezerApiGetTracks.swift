//
//  DeezerApiGetTracks.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

struct DeezerApiGetTracks: Codable {
    let tracks: [DeezerApiTrack]
    enum CodingKeys: String, CodingKey {
        case tracks = "data"
    }
}
