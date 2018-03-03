//
//  AddWordViewController.swift
//  Lin
//
//  Created by Xinyi Zhuang on 02/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit
import ReactiveSwift
import Snakepit
import ReactiveCocoa

class AddWordViewController: UIViewController {
  @IBOutlet weak private var englishTextField: UITextField!
  @IBOutlet weak private var chineseTextField: UITextField!
  @IBOutlet weak private var addButton: UIButton!
  var viewModel: AddWordViewModel!

  override func viewDidLoad() {
    englishTextField.becomeFirstResponder()
    viewModel.isButtonEnable.signal.observeValues { [weak self] in
      print("state \($0)")
      self?.addButton.isEnabled = $0
      self?.addButton.alpha = $0 ? 1 : 0.5
    }
    englishTextField.reactive.continuousTextValues.observeValues { [weak self] in
      self?.viewModel.englishWordChanged(english: $0)
    }
    chineseTextField.reactive.continuousTextValues.observeValues { [weak self] in
      self?.viewModel.chineseWorldChanged(chinese: $0)
    }
    addButton.onTouch(for: .touchUpInside) { [weak self] in
      self?.viewModel.buttonPressed()
      self?.navigationController?.popViewController(animated: true)
    }
    viewModel.viewDidLoad()
  }
}
