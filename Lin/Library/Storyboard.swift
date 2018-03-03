//
//  File.swift
//  Lin
//
//  Created by Xinyi Zhuang on 02/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import Foundation
import Snakepit

enum Storyboard: String, StoryboardGettable {
  case Main

  var bundle: Bundle? {
    return Bundle.main
  }
}
