//
//  CreateConsumoBebidasViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 14/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class CreateConsumoBebidasViewController: UITableViewController {

    //var que paso del controlador anterior
    var currentOrder = [(Product,String)]()
    
    
    //var que no traigo del controlador anterior
    let cellId = "cellId"
    
    let loadingView = LoadingView(message: "Cargando")
    let mensajeError = MensajeError(ImageName: "sin_conexion", Titulo: "Oops!", Mensaje: "No hay conexion a internet")
    
    var productos : [Product]?
    
    var cantidad = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SETTING TABLEVIEW
        tableView.register(FormularioConsumoTableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.bounces = false
        
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: false)
        
        //SETTING NAVBAR
        navigationItem.title = "Nueva orden(2/4)"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"arrow"), style: .plain, target: self, action: #selector(self.siguiente))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atras", style:UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        fetchingBebidas()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            self.mensajeError.hideElements()
            
        })
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: METODO DEL TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! FormularioConsumoTableViewCell
        
        
        cell.mySteeper.touchUpInside = { steeper in
            
            self.cantidad = "\(Int(steeper.value))"
            
            cell.cantidadLabel.text = "Cant:\(Int(steeper.value))"
            
            if cell.isSelected == true{
                
                print("el numero de ordenes es: \(self.currentOrder.count)")
                
                var i = 0
                
                for x in self.currentOrder{
                    
                    if (x.0.nombre == cell.titleLabel.text!){
                        
                        print(self.currentOrder[i].0.nombre)
                        
                        self.currentOrder[i].1 = self.cantidad
                    }
                    
                    i = i + 1
                    
                    print("entre \(i) veces al ciclo")
                    
                }
                print("celda seleccionada")
            }
            
        }
        
        cell.titleLabel.text = productos?[indexPath.row].nombre
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "bebidas"
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as! FormularioConsumoTableViewCell
        
        currentOrder.append((productos![indexPath.row], currentCell.cantidadLabel.text!))
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let currentId = productos?[indexPath.row].id
        
        currentOrder = currentOrder.filter { $0.0.id != currentId }
        
        
        
    }
    
    
    //MARK:FETCHING DATA
    func fetchingBebidas(){
        
        print("entre al fetching")
        
        mensajeError.hideElements()
        loadingView.showMenuLoad()
        
        
        let url = URL(string: "\(HttpRuta.ruta)/products")
        
        print(url!)
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard data != nil else {
                print("error de data: \(error!)")
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingView.hideLoadingView()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Por favor revise su conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
                        
                        if self.productos?.count == nil{
                            //run your function here
                            
                            self.mensajeError.showElements()
                            self.mensajeError.showView()
                            self.mensajeError.reloadButton.addTarget(self, action: #selector(self.reloadData), for: .touchDown)
                            self.tableView.isHidden = true
                        }
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                })
                
                return
                
            }
            
            
            do{
                
                if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [[String:AnyObject]] {
                    
                    //     print(json)
                    
                    self.productos = [Product]()
                    
                    
                    for prod in json{
                        
                        let producto = Product()
                        
                        let tipo = prod["tipo"] as! String
                        
                        if tipo == "2"{
                            
                            producto.id = prod["id"] as! Int
                            producto.nombre = prod["nombre"] as! String
                            producto.tipo = tipo
                            self.productos?.append(producto)
                        }
                        
                    }
                    
                    //recargo la data del collectionView de manera asincrona
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                        self.loadingView.hideLoadingView()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                    })
                    
                }
                
                
                
            } catch let jsonError {
                print("error en el json: \(jsonError)")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.loadingView.hideLoadingView()
                self.mensajeError.showElements()
                self.mensajeError.showView()
                self.mensajeError.reloadButton.addTarget(self, action: #selector(self.reloadData), for: .touchDown)
                self.tableView.isHidden = true
                
            }
            
            
        }.resume()
        
        
    }
    
    
    func siguiente(){
        
        let consumoPostreVc = CreateConsmumoPostresViewController(style: .grouped)
        consumoPostreVc.currentOrder = currentOrder
        
        navigationController?.pushViewController(consumoPostreVc, animated: true)
        
    }

    
    
    
    func reloadData(){
    
        fetchingBebidas()
        
    }
    

}
