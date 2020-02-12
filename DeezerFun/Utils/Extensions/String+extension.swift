//
//  String+extension.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import Foundation

extension String {
    func toDateWith(format: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from: self)!
    }
}
