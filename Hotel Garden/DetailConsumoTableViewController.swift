//
//  DetailConsumoTableViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 29/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class DetailConsumoTableViewController: UITableViewController {
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SETTING TABLEVIEW
        tableView.backgroundColor = UIColor(white: 1, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(DetailConsumoTableViewCell.self, forCellReuseIdentifier: cellId)
        
        //SETTING NAVBAR
        navigationItem.title = "Detalle de orden"
        navigationController?.navigationBar.tintColor = .white


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        return cell
    }
 

  

 

}
