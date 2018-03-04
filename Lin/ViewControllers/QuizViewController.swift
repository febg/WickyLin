//
//  QuizViewController.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit
import ReactiveSwift

class QuizViewController: UIViewController {
  @IBOutlet private weak var questionLabel: UILabel!
  @IBOutlet private weak var textField: UITextField!
  var viewModel: QuizViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    textField.becomeFirstResponder()
    viewModel.currentQuestion.signal.observeValues { [weak self] in
      self?.questionLabel.text = $0
    }
  }

  @IBAction func buttonPressed(_ sender: UIButton) {
  }
}

class QuizViewModel {
  public let currentQuestion: Property<String>
  public let completion: Property<Void>

  private let _completion = MutableProperty(())
  private let _currentQuestion = MutableProperty(String())
  private let _wordList = MutableProperty([Word]())
  private let _viewDidLoad = MutableProperty(())

  private init() {
    currentQuestion = .init(capturing: _currentQuestion)
    completion = .init(capturing: _completion)
  }

  convenience init(_ wordsList: [Word]) {
    self.init()
    _wordList.value = wordsList
  }

  func check(forQuestion: String, with answer: String) {
    var i = 0
    while i < _wordList.value.count {
      let word = _wordList.value[i]
      if word.subtitle == forQuestion && word.title.lowercased() == answer.lowercased() {
        _wordList.value.remove(at: i)
        return
      }
      i += 1
    }
  }
}

extension Array where Element == Word {
  func contains(_ w: Word) -> Bool {
    for word in self {
      if word.title == w.title && word.subtitle == word.subtitle { return true }
    }
    return false
  }
}
