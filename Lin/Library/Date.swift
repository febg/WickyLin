//
//  Date.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import Foundation

extension Date {
  var dateString: String {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_cn")
    formatter.dateStyle = .full
    formatter.timeStyle = .short
    formatter.doesRelativeDateFormatting = true
    return formatter.string(from: self)
  }
}
