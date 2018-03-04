//
//  HistoryViewModel.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class HistoryViewModel {
  public let history: Property<[History]>
  public let isLoading: Property<Bool>

  private let _history = MutableProperty([History]())
  private let _getHistory: SignalProducer<[History], NoError>
  private let _isLoading = MutableProperty(false)
  init() {
    history = .init(capturing: _history)
    isLoading = .init(capturing: _isLoading)
    _getHistory = Storage.getHistory()
  }
  func loadData() {
    _getHistory.on(
      starting: { [weak self] in self?._isLoading.value = true },
      terminated: { [weak self] in self?._isLoading.value = false })
      .startWithValues { [weak self] in self?._history.value = $0 }
  }
}

extension Storage {
  static func getHistory() -> SignalProducer<[History], NoError> {
    return .init { sink, lifetime in
      var results = [History]()
      for file in allFileNames() {
        results += [retrieve(file, from: .documents, as: History.self)]
      }
      sink.send(value: results)
      sink.sendCompleted()
      lifetime.observeEnded { print("done") }
    }
  }
}
