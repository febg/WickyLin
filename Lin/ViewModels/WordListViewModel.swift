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
  private let _save = MutableProperty(())

  init() {
    wordList = .init(capturing: _wordList)
    let nums = 10
    let navTitleStream = Signal.merge(
      wordList.signal.filter { $0.count < nums }.map { "你还需要添加\(nums - $0.count)个单词" },
      wordList.signal.filter { $0.count >= nums }.map { "一共\($0.count)个单词" }
    )
    navTitle = .init(initial: String(), then: navTitleStream)

    let buttonInfoStream = wordList.signal
      .map { $0.count >= nums ? ButtonState.startQuiz : ButtonState.addWord}
      .combineLatest(with: _viewDidLoad.signal)
      .map { $0.0 }
    buttonInfo = .init(initial: .addWord, then: buttonInfoStream)
    buttonBackgroundColor = .init(buttonInfo.map { $0 == .addWord ? .blue : .green })
    wordList.signal.filter { $0.count >= 1 }.sample(on: _save.signal).observeValues {
      let history = History(date: Date(), list: $0)
      Storage.store(history, to: .documents, as: Date().dateString)
      print("saved")
    }
  }

  func save() { _save.value = () }
  func add(word: Word) { _wordList.value.append(word) }
  func viewDidLoad() { _viewDidLoad.value = ()}
  func addInitial(wordList: [Word]) {
    _wordList.value = wordList
  }
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
