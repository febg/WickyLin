//
//  WordListViewModel.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit
import ReactiveSwift

class WordListViewModel {
  public let wordList: Property<[Word]>

  private let _wordList = MutableProperty([Word]())
  private let _viewWillAppear = MutableProperty(())

  init() {
    wordList = .init(capturing: _wordList)
  }

  func add(word: Word) {
    _wordList.value.append(word)
  }

  func viewWillAppear() { _viewWillAppear.value = ()}
}
