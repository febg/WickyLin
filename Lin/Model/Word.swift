//
//  Word.swift
//  Lin
//
//  Created by Xinyi Zhuang on 02/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import Foundation

struct Word: Codable {
  let title: String
  let subtitle: String
  var passed: Bool?

  init(_ formData: (String, String)) {
    title = formData.0
    subtitle = formData.1
  }

  mutating func markPassed() {
    passed = true
  }
}
