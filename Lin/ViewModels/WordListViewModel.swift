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
  public let navTitle: Property<String>
  public let buttonInfo: Property<ButtonState>
  public let buttonBackgroundColor: Property<UIColor>

  private let _wordList = MutableProperty([Word]())
  private let _viewDidLoad  = MutableProperty(())

  init() {
    wordList = .init(capturing: _wordList)
    let nums = 3
    let placeholder = "今天要背\(nums)个单词"
    let navTitleStream = Signal.merge(
      _viewDidLoad .signal.map { placeholder },
      wordList.signal.filter { $0.isEmpty }.map { _ in placeholder },
      wordList.signal.filter { $0.count < nums }.map { "你还需要添加\(nums - $0.count)个单词" },
      wordList.signal.filter { $0.count >= nums }.map { "一共\($0.count)个单词" }
    )
    navTitle = .init(initial: placeholder, then: navTitleStream)
    buttonInfo = .init(wordList.map { $0.count >= nums ? .startQuiz : .addWord })
    buttonBackgroundColor = .init(buttonInfo.map { $0 == .addWord ? .blue : .green })
  }

  func add(word: Word) { _wordList.value.append(word) }
  func viewDidLoad() { _viewDidLoad .value = ()}
}

enum ButtonState: Int {
  case addWord
  case startQuiz

  var title: String {
    switch self {
    case .addWord: return "点击添加今天的单词"
    case .startQuiz: return "开始考试"
    }
  }
}
