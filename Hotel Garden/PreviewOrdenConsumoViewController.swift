//
//  PreviewOrdenConsumoViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 14/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit
import StretchHeader

class PreviewOrdenConsumoViewController: UITableViewController {
    
    //var que traigo del controlador anterior
    var currentOrder = [(Product,String)]()
    
    
    //var que no traigo del contralador anterior
    let cellId = "cellId"

    var comidasArray = [(Product,String)]()
    var bebidasArray = [(Product,String)]()
    var postresArray = [(Product,String)]()
    
    var header : StretchHeader!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaderView()
        
        tableView.register(OrderConsumoTableViewCell.self, forCellReuseIdentifier: cellId)

        comidasArray = currentOrder.filter({ $0.0.tipo == "B" })
        bebidasArray = currentOrder.filter({ $0.0.tipo == "C" })
        postresArray = currentOrder.filter({ $0.0.tipo == "A" })
        
        //SETTING NAVBAR
        navigationItem.title = "Previo de la orden"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"arrow"), style: .plain, target: self, action: #selector(self.siguiente))

        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:METODOS DEL TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return comidasArray.count
            
        case 1:
            return bebidasArray.count
            
        default:
            return postresArray.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! OrderConsumoTableViewCell
        
        switch indexPath.section {
        case 0:
            
            cell.titleLabel.text = comidasArray[indexPath.row].0.nombre
            cell.cantidadLabel.text = "\(comidasArray[indexPath.row].1)"
            break
            
        case 1:
            cell.titleLabel.text = bebidasArray[indexPath.row].0.nombre
            cell.cantidadLabel.text = "\(bebidasArray[indexPath.row].1)"
            break
            
        default:
            cell.titleLabel.text = postresArray[indexPath.row].0.nombre
            cell.cantidadLabel.text = "\(postresArray[indexPath.row].1)"
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Comidas"
            
        case 1:
            
            return "Bebidas"
            
        default:
            return "Postres"
        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    

    //MARK: METODO PARA SETEAR EL HEADER DE LA TABLA
    func setupHeaderView() {
        
        let options = StretchHeaderOptions()
        options.position = .underNavigationBar
        
        header = StretchHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 220),
                                 imageSize: CGSize(width: view.frame.size.width, height: 220),
                                 controller: self,
                                 options: options)
        
        header.imageView.image = UIImage(named: "restaurante")
        header.imageView.contentMode = .scaleToFill
        header.imageView.layer.masksToBounds = true
        tableView.tableHeaderView = header
    }
    
    
    // MARK: - ScrollView Delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
        
    }
    
    
    //MARK:METODO PARA SUBIR LA ORDEN DE CONSUMO
    func siguiente(){
    
        
    
    }

}
