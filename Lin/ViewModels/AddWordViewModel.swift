//
//  AddWordViewModel.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import Foundation
import ReactiveSwift

class AddWordViewModel {
  public let isButtonEnable: Property<Bool>
  public let wordListViewModel: Property<WordListViewModel>

  private let _englishWordChanged = MutableProperty<String?>(nil)
  private let _chineseWorldChanged = MutableProperty<String?>(nil)
  private let _buttonPressed = MutableProperty(())
  private let _viewDidLoad = MutableProperty(())

  init(_ wordListVM: WordListViewModel) {
    wordListViewModel = .init(value: wordListVM)
    let formData = Signal.combineLatest(
      _englishWordChanged.signal.skipNil(),
      _chineseWorldChanged.signal.skipNil()
    )

    let buttonEnable = Signal.merge(
      formData.map { !$0.0.isEmpty && !$0.1.isEmpty },
      _viewDidLoad.signal.map { false }
      )
    isButtonEnable = .init(initial: false, then: buttonEnable)

    isButtonEnable.signal
      .combineLatest(with: formData)
      .filter { $0.0 == true }
      .map { Word($0.1) }
      .sample(on: _buttonPressed.signal)
      .observeValues { [weak self] in
        self?.wordListViewModel.value.add(word: $0)
    }
  }

  func englishWordChanged(english: String?) { _englishWordChanged.value = english }
  func chineseWorldChanged(chinese: String?) { _chineseWorldChanged.value = chinese }
  func buttonPressed() { _buttonPressed.value = () }
  func viewDidLoad() { _viewDidLoad.value = () }
}
