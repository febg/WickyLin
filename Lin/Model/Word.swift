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

  init(_ formData: (String, String)) {
    title = formData.0
    subtitle = formData.1
  }
}
