//
//  QuizViewController.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import ReactiveCocoa

class QuizViewController: UIViewController {
  @IBOutlet private weak var questionLabel: UILabel!
  @IBOutlet private weak var textField: UITextField!
  @IBOutlet private weak var button: UIButton!
  let viewModel = QuizViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    textField.becomeFirstResponder()
    textField.reactive.continuousTextValues.observeValues { [weak self] in
      self?.viewModel.submit(answer: $0)
    }
    viewModel.testPassed.skipNil().observeValues { [weak self] in
      self?.showAlert(title: "考试通过，再接再厉") { _ in
        self?.navigationController?.popViewController(animated: true)
      }
    }
    viewModel.currentQuestion.observeValues { [weak self] in
      self?.questionLabel.text = $0
      self?.textField.text = nil
    }
    viewModel.buttonState.observeValues { [weak self] in
      self?.button.setTitle($0.0, for: .normal)
      self?.button.backgroundColor = $0.1
    }
    viewModel.viewDidLoad()
  }

  @IBAction func buttonPressed(_ sender: UIButton) {
    viewModel.buttonPressed()
  }
}

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
        guard w == $0 else { continue }
        self._wordList.value.remove(at: index)
        return
      }
    }
  }

  func viewDidLoad() { _viewDidLoad.value = () }
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
