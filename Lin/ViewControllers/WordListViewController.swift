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

    guard navigationController?.presentingViewController != nil else {
      tableView.tableHeaderView = nil
      navigationItem.title = "\(viewModel.wordList.value.count)个单词"
      return
    }
    navigationItem.rightBarButtonItem = .init(
      title: "Close",
      style: .done,
      target: self,
      action: #selector(closePressed)
    )
  }

  @objc func closePressed() {
    guard !self.viewModel.wordList.value.isEmpty else {
      self.navigationController?.dismiss(animated: true, completion: nil)
      return
    }
    showAlert(
      title: "是否保存",
      message: "如果你不保存，这些单词就没有了",
      actions: [.cancel, .custom("保存", .default), .custom("删除", .destructive)],
      type: .actionSheet) {
        if $0.title == AlertButtonType.cancel.description { return }
        if $0.title == "保存" { self.viewModel.save() }
        self.navigationController?.dismiss(animated: true, completion: nil)
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
    cell.textLabel?.text = "英文单词：" + word.title
    cell.detailTextLabel?.text = "中文意思：" + word.subtitle
    return cell
  }
}
