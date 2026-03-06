//
//  ExampleViewController.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

final class ExampleViewController: BaseViewController<ExamplePresenterProtocol>, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sections: [SectionData<String>] = [
        SectionData<String>(id: 0, headerTitle: nil, items: ["Teste 1"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - TableView Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = sections[safe: indexPath.section]?[indexPath.row]
        
        let tableViewCell = UITableViewCell()
        tableViewCell.textLabel?.text = text
        tableViewCell.backgroundColor = .clear
        return tableViewCell
        
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[safe: section]?.headerTitle
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[safe: section]?.footerTitle
    }
    
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let text = sections[safe: indexPath.section]?[indexPath.row] else { return }
        self.presenter?.selectedItem(text)
    }
}

extension ExampleViewController: ExamplePresenterDelegate {
    
}
