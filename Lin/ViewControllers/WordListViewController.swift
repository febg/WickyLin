//
//  WordListViewController.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit
import Snakepit
class WordListViewController: UITableViewController {
  var viewModel = WordListViewModel()

  @IBOutlet private weak var mainButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = .init(frame: .zero)
    viewModel.viewDidLoad()
    viewModel.wordList.signal.observeValues { [weak self] _ in self?.tableView.reloadData() }
    viewModel.navTitle.signal.observeValues { [weak self] in self?.navigationItem.title = $0 }
    viewModel.buttonInfo.signal.observeValues { [weak self] in
      self?.mainButton.tag = $0.rawValue
      self?.mainButton.setTitle($0.title, for: .normal)
    }
    viewModel.buttonBackgroundColor.signal.observeValues { [weak self] in
      self?.mainButton.backgroundColor = $0
    }

    navigationItem.rightBarButtonItem = .init(
      title: "Close",
      style: .done,
      target: self,
      action: #selector(closePressed)
    )
  }

  @objc func closePressed() {
    showAlert(
      title: "是否保存",
      message: "如果你不保存，这些单词就没有了",
      actions: [.cancel, .ok],
      type: .actionSheet) {
        if $0.title == AlertButtonType.ok.description {
          self.navigationController?.dismiss(animated: true, completion: nil)
          // TODO: save wordlist
        }
    }
  }

  @IBAction func buttonPressed(_ sender: UIButton) {
    switch sender.tag {
    case ButtonState.addWord.rawValue:
      let addWordVc = Storyboard.Main.get(AddWordViewController.self)
      addWordVc.viewModel = AddWordViewModel(viewModel)
      navigationController?.pushViewController(addWordVc, animated: true)
    default:
      // TODO: Start QUIZ
      return
    }
  }
}

extension WordListViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.wordList.value.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
    let word = viewModel.wordList.value[indexPath.row]
    cell.textLabel?.text = word.title
    cell.detailTextLabel?.text = word.subtitle + Date().dateString
    return cell
  }
}
