//
//  ConsumosTableViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 20/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class ConsumosTableViewController: UITableViewController {

    let cellId = "cellId"

    let prefs:UserDefaults = UserDefaults.standard
    
    var foodOrders : [FoodOrder]?
    var details : [ArticleList]?
    
    var sweetAlert = SweetAlert()
    
    let loadingView = LoadingView(message: "Cargando")

    
    lazy var refreshControl1: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: .valueChanged)
        return refreshControl
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.addSubview(refreshControl1)
        tableView.register(PreviewConsumoTableViewCell.self, forCellReuseIdentifier: cellId)

        
        //SETTING NAVIGATIONBAR
        navigationItem.title = "Consumos"
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atras", style:UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(crearConsumo))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrdenesCliente()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodOrders?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PreviewConsumoTableViewCell
        
        
        cell.dateLabel.text = foodOrders?[indexPath.row].created_at.reemplazarEspaciosEnBlancoPorBarra().reemplazarGuionesPorSlash()
        
        if let order = foodOrders?[indexPath.row]{
        
            switch order.estatus {
            case "1":
                cell.titleLabel.text = "Por Procesar"
                break
            case "2":
                
                cell.titleLabel.text = "En proceso"
                break
            case "3":
                cell.titleLabel.text = "Procesado"
                break
            default:
                cell.titleLabel.text = "Cancelada"
            }
            
        }
       
        
        var descrip = String()
        
        
        for x in foodOrders![indexPath.row].articles{
            
            descrip += "\(x.descripcion_prod) cantidad: \(x.cantidad_prod) "
            
        }
        
        let aux = "Orden nro: \(foodOrders![indexPath.row].id)\n \(descrip))"
        let msj = aux.substring(to: aux.index(before: aux.endIndex))
        
        
        cell.detailLabel.text = msj
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(foodOrders![indexPath.row].id)
        
        let detailConsumoViewController = DetailConsumoTableViewController(style: .grouped)
        detailConsumoViewController.foodOrder = foodOrders![indexPath.row]
        
        navigationController?.pushViewController(detailConsumoViewController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        
        let borrar = UITableViewRowAction(style: .normal, title: "Borrar") { action, index in
            print("borrar button tapped")
            
            let idFoodOrder = self.foodOrders![index.row].id
            
            switch self.foodOrders![index.row].estatus{
            
            case "1":
                
                print("pase la verificacion")
                
                DispatchQueue.main.async(execute: {
                    
                    let alert = UIAlertController(title: "¡Atencion!", message:"¿Esta seguro que desea borrar esta orden?", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.destructive, handler:  { action in
                        
                        self.deleteFoodOrder(idFoodOrder: idFoodOrder)
                        
                    }))
                    
                    
                    alert.addAction(UIAlertAction(title: "Cancel" , style: UIAlertActionStyle.cancel, handler:  { action in
                        
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                })

                break
                
            default:
                
                DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "¡Error!", message:"solo las ordenes con estatus: 'Por procesar' pueden ser eliminadas", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                }))
                self.present(alert, animated: true, completion: nil)})
                
                break
            }
            
        }
        
        borrar.backgroundColor = UIColor.rgb(231, green: 76, blue: 60)
        
        
        
        let editar = UITableViewRowAction(style: .normal, title: "Editar") { action, index in
            print("editar button tapped")
            
            print(index.row)
            
            let status = self.foodOrders![index.row].estatus
            
            print(status)
            
            if status != "Por procesar"{
                
                DispatchQueue.main.async(execute: {
                    
                    let alert = UIAlertController(title: "¡Error!", message:"las ordenes con estatus: '\(status)' no pueden ser modificadas", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                })
                
            }else{
                
                let updateConsumoComidas = UpdateConsumoComidasViewController(style: .grouped)
                updateConsumoComidas.foodOrder = self.foodOrders![index.row]
                
                self.navigationController?.pushViewController(updateConsumoComidas, animated: true)
                
            }
            
        }
        
        editar.backgroundColor = .azul()
        
        return [borrar,editar]
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK:METODO PARA TRAER TODAS LA ORDENES DE CONSUMO DEL CLIENTE
    func fetchOrdenesCliente(){
        
        print("entre al fetching")
        
        // mensajeError.hideElements()
        loadingView.showMenuLoad()
        
        let clientId : Int = prefs.integer(forKey: "ID_CLIENTE") as Int
        
        let url = URL(string: "\(HttpRuta.ruta)/clients/\(clientId)/foodorders")
        
       // print(url!)
        
        print("este es el id del cliente\(clientId)")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard data != nil else {
                print("error de data: \(error!)")
                
                DispatchQueue.main.async(execute: {
                    
                   // self.loadingView.hideLoadingView()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Por favor revise su conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
                        
                        if self.foodOrders?.count == nil{
                            //run your function here
                            
                            //  self.mensajeError.showElements()
                            //  self.mensajeError.showView()
                            //                  self.mensajeError.reloadButton.addTarget(self, action: #selector(self.reloadData), for: .touchDown)
                            self.loadingView.hideLoadingView()
                            self.tableView.isHidden = true
                        }
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                })
                
                return
                
                
            }
            
            
            do{
                
                if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject] {
                    
                    self.foodOrders = [FoodOrder]()
                    
                    print(json)
                    
                    let foodOrderArray = json["ordenes"] as! [[String:AnyObject]]
                    
                    let ordenes = foodOrderArray
                    
                    for x in ordenes{
                        
                        let foodOrder = FoodOrder()
                        
                        foodOrder.id = x["id"] as! Int
                        //foodOrder.client_id = Int(x["client_id"])
                        foodOrder.created_at = x["created_at"] as! String
                        foodOrder.estatus = x["estatus"] as! String
                        foodOrder.location_id = x["location_id"] as! Int
                        foodOrder.origin_id = x["origin_id"] as! Int
                        foodOrder.reservation_id = "\(x["reservations_id"] as! Int)"
                        foodOrder.roomId = x["room_id"] as! Int
                        foodOrder.updated_at = x["updated_at"] as! String
                        foodOrder.user_id = x["user_id"] as! Int
                        foodOrder.operation_id = "\(x["operation_id"] as! Int)"
                        
                        self.foodOrders?.append(foodOrder)
                        
                    }
                    
                    
                    //ecargo la data del collectionView de manera asincrona
                    DispatchQueue.main.async(execute: {
                        for x in self.foodOrders!{
                            self.fetchDetailsOrders(Operation: x.operation_id, foodOrder: x)
                        }

                        self.tableView.reloadData()
                        self.loadingView.hideLoadingView()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                    })
                    
                }
                
            } catch let jsonError {
                print("error en el json: \(jsonError)")
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.loadingView.hideLoadingView()
                //                self.mensajeError.showElements()
                //                self.mensajeError.showView()
                //                self.mensajeError.reloadButton.addTarget(self, action: #selector(self.reloadData), for: .touchDown)
                //                self.tableView.isHidden = true
                
            }
            
        }.resume()
        
    }
    
    
    
    //MARK:METODO PARA TRAER LOS DETALLES DE UNA ORDEN
    func fetchDetailsOrders(Operation id : String, foodOrder :FoodOrder){
        
        print("entre al detail")
        
        //  mensajeError.hideElements()
        loadingView.showMenuLoad()
        
        let url = URL(string: "\(HttpRuta.ruta)/operations/\(id)/details")
        
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
                        
                        
                        if self.foodOrders?.count == nil{
                            //run your function here
                            
                            //   self.mensajeError.showElements()
                            //   self.mensajeError.showView()
                            //  self.mensajeError.reloadButton.addTarget(self, action: #selector(self.reloadData), for: .touchDown)
                            self.tableView.isHidden = true
                        }
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                })
                
                return
                
            }
            
            
            do{
                
                if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject] {
                    
                    
                    self.details = [ArticleList]()
                    
                    
                    print(json)
                    
                    let detailsArray = json["detalles"] as? [[String:AnyObject]]
                    
                    if let details = detailsArray {
                        
                        for x in details{
                            
                            let article = ArticleList()
                            
                            article.id = x["id"] as! Int
                            article.operation_id = x["operation_id"] as! Int
                            article.cantidad_prod = x["cantidad_prod"] as! Int
                            article.descripcion_prod = x["descripcion_prod"] as! String
                            article.created_at = x["created_at"] as! String
                            article.updated_at = x["updated_at"] as! String
                            article.updated_at = x["updated_at"] as! String
                            article.tipo = x["tipo"] as! Int
                            
                            self.details?.append(article)
                            foodOrder.articles = self.details!
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
                //  self.mensajeError.showElements()
                //  self.mensajeError.showView()
                //  self.mensajeError.reloadButton.addTarget(self, action: #selector(self.reloadData), for: .touchDown)
                self.tableView.isHidden = true
                
            }
            
        }.resume()
        
        
    }
    
    func deleteFoodOrder(idFoodOrder id : Int){
        
        
        loadingView.showMenuLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/foodorders/\(id)")!)
        
        
        
        request.httpMethod = "DELETE"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error!)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
                
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingView.hideLoadingView()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Por favor revise su conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                })
                
            }
            
            //Todo salio bn
            DispatchQueue.main.async(execute: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.loadingView.hideLoadingView()
                _ = self.sweetAlert.showAlert("Completado!", subTitle: "Su orden de mantenimiento ha sido borrada con exito", style: AlertStyle.success)
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString!)")
                self.fetchOrdenesCliente()
            })
            
            
            //aqui poner el sweet alert de error
        }
        
        task.resume()
        
    }

    //MARK:METODO PARA CREAR CONSUMO
    func crearConsumo(){
        
        let crearConsumoVc = CreateConsumoViewController(style: .grouped)
        navigationController?.pushViewController(crearConsumoVc, animated: true)
        
    }
    
    
    //MARK: METODO QUE SE USA PARA RECARGAR LA TABLA CUANDO SE HACE PULLDOWN
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.foodOrders = nil
        
       // fetchOrdenesCliente()
        refreshControl.endRefreshing()
    }

}
