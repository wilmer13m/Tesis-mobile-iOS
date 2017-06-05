//
//  CreateMantenimientoViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 4/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class CreateMantenimientoViewController: UITableViewController {

    let cellId1 = "cellId1"
    let cellId2 = "cellId2"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //SETTING TABLEVIEW
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        
        tableView.register(FormularioServicioTableViewCell.self, forCellReuseIdentifier: cellId1)
        tableView.register(ContinueTableViewCell.self, forCellReuseIdentifier: cellId2)
        
        
        //SETTING NAVBAR
        navigationItem.title = "Nueva orden"
        navigationController?.navigationBar.tintColor = .white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellId1) as! FormularioServicioTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: cellId2) as! ContinueTableViewCell
        
        if indexPath.row == 0{
            
            return cell1
            
        }else{
            return cell2
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0{
            
            return 110
            
        }else{
            
            return 120
        }
    
    }



}
