//
//  DeezerNativeError.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 9/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

struct DeezerNativeError: Error, Codable {
    var type: String
    var message: String
    var code: Int
    
    enum LevelUpCodingKeys: String, CodingKey {
        case error
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: LevelUpCodingKeys.self)
        let deezerNativeErrorContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
        type = try deezerNativeErrorContainer.decode(String.self, forKey: .type)
        message = try deezerNativeErrorContainer.decode(String.self, forKey: .message)
        code = try deezerNativeErrorContainer.decode(Int.self, forKey: .code)
    }
    
    var localizedDescription: String {
        return message
    }
}
