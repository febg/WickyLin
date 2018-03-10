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
import Snakepit

class QuizViewController: UIViewController {
  @IBOutlet private weak var questionLabel: UILabel!
  @IBOutlet private weak var textField: UITextField!
  @IBOutlet private weak var button: UIButton!
  let viewModel = QuizViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    textField.becomeFirstResponder()
    navigationItem.leftBarButtonItem =
      UIBarButtonItem(title: "放弃考试", style: .done, target: self, action: #selector(tapOnBackButton))
    textField.reactive.continuousTextValues.observeValues { [weak self] in
      self?.viewModel.submit(answer: $0)
    }
    viewModel.testPassed.skipNil().observeValues { [weak self] in
      self?.showAlert(title: "考试通过，再接再厉") { _ in
        Analytics.logEvent("TestPassed", parameters: ["date": Date().description])
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
    viewModel.cheatting.observeValues { [weak self] in
      guard $0 == true else { return }
      self?.showAlert(title: "发现考试作弊!!")
    }
    viewModel.viewDidLoad()
  }

  @IBAction func buttonPressed(_ sender: UIButton) {
    viewModel.buttonPressed()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.viewWillDisappear()
  }

  @objc func tapOnBackButton() {
    showAlert(
      title: "注意",
      message: "放弃未完成的考试将被视为作弊行为",
      actions: [.ok, .cancel], type: .actionSheet) { [weak self] in
        guard $0.title == AlertButtonType.ok.description else { return }
        self?.navigationController?.popViewController(animated: true)
    }
  }
}
