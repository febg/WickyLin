//
//  HistoryViewController.swift
//  Lin
//
//  Created by Xinyi Zhuang on 03/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    let footSize = CGSize(width: view.frame.width, height: 44)
    tableView.tableFooterView = UIView(frame: .init(origin: .zero, size: footSize))
  }
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    let nav = UINavigationController(rootViewController: Storyboard.Main.get(WordListViewController.self))
    present(nav, animated: true, completion: nil)
  }
}

extension HistoryViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
    cell.textLabel?.text = "hahaha" + Date.init(timeIntervalSince1970: 100000000).dateString
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 40
  }
}
