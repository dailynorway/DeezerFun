//
//  DeezerApiError.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 9/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

enum DeezerApiError: Error {
    case dataNotReceived
    case urlSession(Error)
    case decoding(DecodingError)
    case deezerNative(DeezerNativeError)
    
    var localizedDescription: String {
        switch self {
        case .dataNotReceived:
            return NSLocalizedString("API did not return data", comment: "")
        case .urlSession(let error):
            return error.localizedDescription
        case .decoding(let error):
            return error.localizedDescription
        case .deezerNative(let error):
            return error.localizedDescription
        }
    }
}
