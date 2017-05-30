//
//  ServiciosViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 28/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class ServicioViewController: UITableViewController {

    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //SETTING TABLEVIEW
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        
        //SETTING NAVIGATIONBAR
        navigationItem.title = "Servicios"
        
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(crearServicio))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        navigationController?.navigationBar.tintColor = .white
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:METODOS DEL TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        return cell!
        
    }

    func crearServicio(){
        
        
    
    }

}
