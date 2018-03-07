//
//  QuizViewController.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Firebase

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
        Analytics.logEvent("Test Passed", parameters: ["date": Date()])
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
