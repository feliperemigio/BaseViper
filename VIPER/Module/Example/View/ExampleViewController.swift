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
    
    private var section: SectionData<String> = SectionData<String>(id: 0,
                                                                 headerTitle: nil,
                                                                 items: ["Teste 1"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - TableView Data Source
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = self.section.items[indexPath.row]
        
        let tableViewCell = UITableViewCell()
        tableViewCell.textLabel?.text = text
        tableViewCell.backgroundColor = .clear
        return tableViewCell
        
    }
    
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.section.items.indices.contains(indexPath.row) else { return }
        let text = self.section.items[indexPath.row]
        self.presenter?.selectedItem(text)
    }
}

extension ExampleViewController: ExamplePresenterDelegate {
    
}
