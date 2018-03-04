//
//  HistoryViewController.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit
import Snakepit

class HistoryViewController: UITableViewController {

  let viewModel = HistoryViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    let footSize = CGSize(width: view.frame.width, height: 44)
    tableView.tableFooterView = UIView(frame: .init(origin: .zero, size: footSize))
    let control = UIRefreshControl()
    control.addTarget(self, action: #selector(loadData), for: .valueChanged)
    refreshControl = control
    viewModel.history.signal.observeValues { [weak self] _ in
      self?.tableView.reloadData()
      self?.refreshControl?.endRefreshing()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadData()
  }

  @objc func loadData() {
    viewModel.loadData()
    navigationItem.title = "\(viewModel.history.value.count)条记录"
  }
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    let nav = UINavigationController(rootViewController: Storyboard.Main.get(WordListViewController.self))
    present(nav, animated: true, completion: nil)
  }
}

extension HistoryViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
    let history = viewModel.history.value[indexPath.row]
    cell.textLabel?.text = history.date.dateString
    cell.detailTextLabel?.text = "\(history.list.count)个单词"
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.history.value.count
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let history = viewModel.history.value[indexPath.row]
    let wordListVc = Storyboard.Main.get(WordListViewController.self)
    wordListVc.viewModel.addInitial(wordList: history.list)
    navigationController?.pushViewController(wordListVc, animated: true)
  }
}
