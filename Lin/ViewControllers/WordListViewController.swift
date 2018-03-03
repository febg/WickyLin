//
//  WordListViewController.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit

class WordListViewController: UITableViewController {
  var viewModel = WordListViewModel()

  @IBOutlet private weak var mainButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = .init(frame: .zero)
    viewModel.wordList.signal.observeValues { [weak self] _ in self?.tableView.reloadData() }
    viewModel.navTitle.signal.observeValues { [weak self] in
      self?.navigationItem.title = $0
      print($0)
    }
    viewModel.buttonInfo.signal.observeValues { [weak self] in
      self?.mainButton.tag = $0.rawValue
      self?.mainButton.setTitle($0.title, for: .normal)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.viewWillAppear()
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
    cell.detailTextLabel?.text = word.subtitle
    return cell
  }
}
