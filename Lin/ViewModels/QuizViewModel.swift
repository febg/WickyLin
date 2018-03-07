//
//  QuizViewModel.swift
//  Lin
//
//  Created by Xinyi Zhuang on 06/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Firebase

class QuizViewModel {
  public let currentQuestion: Signal<String?, NoError>
  public let testPassed: Signal<Void?, NoError>
  public let buttonState: Signal<(String, UIColor), NoError>

  private let _wordList = MutableProperty([Word]())
  private let _viewDidLoad = MutableProperty(())
  private let _buttonPressed = MutableProperty(())
  private let _answer = MutableProperty<String?>(nil)

  init() {
    currentQuestion = _wordList.signal
      .combineLatest(with: _viewDidLoad.signal)
      .map { $0.0.next?.subtitle }
    testPassed = currentQuestion
      .map { $0 == nil ? () : nil }

    let checkAnswer = Signal.combineLatest(
      _wordList.signal,
      _answer.signal.skipNil(),
      currentQuestion.skipNil()
      )
      .map { $0.0.check(answer: $0.1, for: $0.2) }

    let checkAnswerOnButtonPress = checkAnswer.sample(on: _buttonPressed.signal)
    buttonState = Signal.merge(
      checkAnswerOnButtonPress.filter { $0 == nil }.map { _ in ("回答错误，再试一次", .red) },
      _answer.signal.skipNil().map { _ in ("确定", .lightBlue) }
    )
    checkAnswerOnButtonPress.skipNil().observeValues {
      for (index, w) in self._wordList.value.enumerated() {
        guard w == $0 else {
          Analytics.logEvent("Submited Answer", parameters: ["word": $0, "result": false])
          continue
        }
        Analytics.logEvent("Submited Answer", parameters: ["word": $0, "result": true])
        self._wordList.value.remove(at: index)
        return
      }
    }
  }

  func viewDidLoad() {
    _viewDidLoad.value = ()
    Analytics.logEvent("Started A New Quiz", parameters: ["date": Date()])
  }
  func submit(answer: String?) { _answer.value = answer }
  func buttonPressed() { _buttonPressed.value = () }
  func startQuiz(for wordList: [Word]) { _wordList.value = wordList }
}

extension Array where Element == Word {
  func check(answer: String, for question: String) -> Word? {
    for word in self {
      guard word.subtitle == question,
        word.title.lowercased() == answer.lowercased() else { continue }
      return word
    }
    return nil
  }

  var next: Word? {
    for word in self {
      guard let p = word.passed, p == false else { return word }
    }
    return nil
  }
}

extension Word: Equatable {
  static func == (lhs: Word, rhs: Word) -> Bool {
    return lhs.title == rhs.title && lhs.subtitle == rhs.subtitle
  }
}
