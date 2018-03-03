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

  private let _wordList = MutableProperty([Word]())
  private let _viewWillAppear = MutableProperty(())

  init() {
    wordList = .init(capturing: _wordList)

    let placeholder = "今天要背10个单词"
    let navTitleStream = Signal.merge(
      _viewWillAppear.signal.map { placeholder },
      wordList.signal.filter { $0.isEmpty }.map { _ in placeholder },
      wordList.signal.filter { !$0.isEmpty }.map { $0.count }.map { "你还需要添加\(10 - $0)个单词" }
    )
    navTitle = .init(initial: placeholder, then: navTitleStream)

    let buttonInfoStream = wordList.signal
      .map { $0.count >= 10 ? ButtonState.startQuiz : ButtonState.addWord }
    buttonInfo = .init(initial: .addWord, then: buttonInfoStream)
  }

  func add(word: Word) { _wordList.value.append(word) }
  func viewWillAppear() { _viewWillAppear.value = ()}
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
