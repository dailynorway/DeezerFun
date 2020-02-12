//
//  ErrorHandler.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 9/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

class ErrorHandler {
    func validateResponse<T>(data: Data?, error: Error?, completionHandler: @escaping (Result<T, DeezerApiError>) -> Void) -> Bool {
        guard error == nil else {
            completionHandler(Result.failure(.urlSession(error!)))
            return false
        }
        
        guard let data = data else {
            completionHandler(Result.failure(.dataNotReceived))
            return false
        }
        
        if let deezerNativeError = try? JSONDecoder().decode(DeezerNativeError.self, from: data) {
            completionHandler(Result.failure(.deezerNative(deezerNativeError)))
            return false
        }
        return true
    }
}
