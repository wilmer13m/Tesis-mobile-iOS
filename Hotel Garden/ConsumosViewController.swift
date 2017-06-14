//
//  ConsumosViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 28/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class ConsumoViewController: UITableViewController {

    let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //SETTING TABLEVIEW
        tableView.register(PreviewConsumoTableViewCell.self, forCellReuseIdentifier: cellId)
        
        
        //SETTING NAVIGATIONBAR
        navigationItem.title = "Consumos"
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atras", style:UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(crearConsumo))

        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: METODOS DEL TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PreviewConsumoTableViewCell
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailConsumoViewController = DetailConsumoTableViewController(style: .plain)
        navigationController?.pushViewController(detailConsumoViewController, animated: true)
    }
    
    
    //MARK:METODO PARA CREAR CONSUMO
    func crearConsumo(){

        let crearConsumoVc = CreateConsumoViewController(style: .grouped)
        navigationController?.pushViewController(crearConsumoVc, animated: true)

        
        
    }
    
}
