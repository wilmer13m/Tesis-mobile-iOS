//
//  PutConsumoViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 18/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit
import StretchHeader



class PutConsumoViewController: UITableViewController,SweetAlertDelegate {

    //var que traigo del controlador anterior
    var currentOrder = [(Product,String)]()
    var foodOrder = FoodOrder()
    
    
    //var que no traigo del contralador anterior
    let cellId = "cellId"
    
    var comidasArray = [(Product,String)]()
    var bebidasArray = [(Product,String)]()
    var postresArray = [(Product,String)]()
    
    let mensajeError = MensajeError(ImageName: "sin_conexion", Titulo: "Oops!", Mensaje: "No hay conexion a internet")
    let loadingView = LoadingView(message: "Cargando...")
    
    let prefs:UserDefaults = UserDefaults.standard
    
    var sweetAlert = SweetAlert()
    
    var header : StretchHeader!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHeaderView()
        
        sweetAlert.sweetDelegate = self
        
        tableView.register(OrderConsumoTableViewCell.self, forCellReuseIdentifier: cellId)
        
        comidasArray = currentOrder.filter({ $0.0.tipo == "B" })
        bebidasArray = currentOrder.filter({ $0.0.tipo == "C" })
        postresArray = currentOrder.filter({ $0.0.tipo == "A" })
        
        //SETTING NAVBAR
        navigationItem.title = "Previo de la orden"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"arrow"), style: .plain, target: self, action: #selector(self.editDetailOrder))
        
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
            cell.cantidadLabel.text = "\(comidasArray[indexPath.row].1.replacingOccurrences(of: "Cant:", with: ""))"
            break
            
        case 1:
            cell.titleLabel.text = bebidasArray[indexPath.row].0.nombre
            cell.cantidadLabel.text = "\(bebidasArray[indexPath.row].1.replacingOccurrences(of: "Cant:", with: ""))"
            break
            
        default:
            cell.titleLabel.text = postresArray[indexPath.row].0.nombre
            cell.cantidadLabel.text = "\(postresArray[indexPath.row].1.replacingOccurrences(of: "Cant:", with: ""))"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func editarConsumo(){
        
        var aux1 = [Int]()
        var aux2 = [Int]()
        var aux3 = [Int]()
        
        for x in currentOrder{
   
            aux1.append(x.0.id)
    
        }
        
        for y in foodOrder.details{
        
            aux2.append(y.product_id)
        
        }
        
        aux3 = aux1.filter{ !aux2.contains($0) }
        
        for x in currentOrder{
            
            for y in aux3 {
            
                if x.0.id == y{
                    
                    let product_id = x.0.id
                    let descripcion_producto = x.0.nombre
                    let cantidad = x.1.replacingOccurrences(of: "Cant:", with: "")
                    let food_order_id = foodOrder.id
                    
                    loadingView.showMenuLoad()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    
                    
                    var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/foodorders/\(food_order_id)/details/")!)
                    request.httpMethod = "POST"
                    let postString = "product_id=\(product_id)&descripcion_producto=\(descripcion_producto)&cantidad=\(cantidad)&food_order_id=\(food_order_id)"
                    
                    print(postString)
                    
                    request.httpBody = postString.data(using: .utf8)
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let _ = data, error == nil else {
                            print("error=\(error!)")
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{           // check for http errors
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(response!)")
                            
                            
                            DispatchQueue.main.async(execute: {
                                
                                self.loadingView.hideLoadingView()
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                
                                let alert = UIAlertController(title: "¡Error 500!", message:"error interno en el servidor", preferredStyle: UIAlertControllerStyle.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                                    
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                                
                            })
                            
                            return
                            
                        }
                            
                            //Todo salio bn
                        else{
                            
                            print("algo salio mal en details")
                            
                            
                        }
                        
                        
                    }
                    
                    
                    task.resume()
                    
                }
            
            }
        
        
        }
        
    }
    
    //MARK: METODO PARA CREAR UN DETAIL
    func editDetailOrder(idFoodOrder id : Int){
        
        
        for x in currentOrder{
        
            
            for y in foodOrder.details{
            
                if x.0.id == y.product_id{
                
                    if x.1.replacingOccurrences(of: "Cant:", with: "") != " \(y.cantidad)"{
                    
                        let product_id = x.0.id
                        let descripcion_producto = y.descripcion_producto
                        let cantidad = x.1.replacingOccurrences(of: "Cant:", with: "")
                        let food_order_id = y.foodOrderId
                        let idDetail = y.id
                        
                        loadingView.showMenuLoad()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                        
                        
                        var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/details/\(idDetail)")!)
                        request.httpMethod = "PUT"
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
                        
                        let postString = "product_id=\(product_id)&descripcion_producto=\(descripcion_producto)&cantidad=\(cantidad)&food_order_id=\(food_order_id)"
                        
                        print(postString)
                        
                        request.httpBody = postString.data(using: .utf8)
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            guard let _ = data, error == nil else {
                                print("error=\(error!)")
                                print("entro al error")
                                return
                            }
                            
                            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{           // check for http errors
                                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                                print("response = \(response!)")
                                print("entro al http")
                                
                                DispatchQueue.main.async(execute: {
                                    
                                    self.loadingView.hideLoadingView()
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    
                                    let alert = UIAlertController(title: "¡Error 500!", message:"error interno en el servidor", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                                        
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                })
                                
                            }else{
                                
                                DispatchQueue.main.async(execute: {
                                    self.editarConsumo()
                                    self.loadingView.hideLoadingView()
                                    _ = self.sweetAlert.showAlert("Completado!", subTitle: "Su orden de mantenimiento ha sido enviada con exito", style: AlertStyle.success)
                                    
                                })
                                
                            }
                            
                        }
                        
                        task.resume()
                    
                    }
                
                }
            
            }
        
        
        }
        
        
        print("toque el boton")
        
        
        
    }
    
    
    func sweetAlertOkButtonPressed() {
        let arrayControllers = self.navigationController?.viewControllers
        
        print("entre al delegado de sweet alert")
        
        var vc : ConsumoViewController?
        for x in arrayControllers!{
            
            if x is ConsumoViewController{
                
                vc = x as? ConsumoViewController
                
            }
            
        }
        navigationController?.popToViewController(vc!, animated: true)
        
    }


}
