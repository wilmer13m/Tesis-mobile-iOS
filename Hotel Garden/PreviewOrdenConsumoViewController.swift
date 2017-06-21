//
//  PreviewOrdenConsumoViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 14/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit
import StretchHeader

class PreviewOrdenConsumoViewController: UITableViewController,SweetAlertDelegate {
    
    //var que traigo del controlador anterior
    var currentOrder = [(Product,String)]()
    var reservation = Reservation()
    var lugar = (String(),Int())
    
    
    //var que no traigo del contralador anterior
    let cellId = "cellId"
    let cellId2 = "cellId2"

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId2)

        comidasArray = currentOrder.filter({ $0.0.tipo == "1" })
        bebidasArray = currentOrder.filter({ $0.0.tipo == "2" })
        postresArray = currentOrder.filter({ $0.0.tipo == "3" })
        
        //SETTING NAVBAR
        navigationItem.title = "Previo de la orden"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"arrow"), style: .plain, target: self, action: #selector(self.crearConsumo))

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
        
        case 2:
            return postresArray.count
        default:
            
            return 1
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
        
        case 2:
            cell.titleLabel.text = postresArray[indexPath.row].0.nombre
            cell.cantidadLabel.text = "\(postresArray[indexPath.row].1.replacingOccurrences(of: "Cant:", with: ""))"
            break
            
        default:
            cell.titleLabel.text = lugar.0
            cell.cantidadLabel.text = " "
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Comidas"
            
        case 1:
            
            return "Bebidas"
            
        case 2:
            return "Postres"
            
        default:
            return "Lugar"
        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
    func crearConsumo(){
        
        
        let alertController = UIAlertController(title: "Confirmacion", message: "¿Esta seguro que desea realizar este consumo?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .destructive) {
            (result : UIAlertAction) -> Void in
            
            self.createOperation()

        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("cancel")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    
    }
    
    
    //MARK:METODO PARA CREAR UN OPERATION
    func createOperation(){
    
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        
        let timeString = formatter.string(from: NSDate() as Date)
        
        print(timeString)
        
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let fecha = "\(components.year!)-\(components.month!)-\(components.day!)"
        
        print(fecha)
        
        
        loadingView.showMenuLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/operations")!)
        request.httpMethod = "POST"
        let postString = "fecha=\(fecha)&hora=\(timeString)"
        
        print(postString)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error!)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                
                //Todo salio bn parseemos el json de la respuesta
            else{
                
                
                do{
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String:AnyObject] {
                        
                        
                        let operationData = json["operation"] as! [String:AnyObject]
                        
                        let operations = Operations()
                        operations.id = operationData["id"] as! Int
                        operations.fecha = operationData["fecha"] as! String
                        operations.hora = operationData["hora"] as! String
                        
                        
                        
                        DispatchQueue.main.async(execute: {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.loadingView.hideLoadingView()
                            self.foodOrder(operat: operations)
                            
                        })
                        
                        
                    }
                    
                } catch let jsonError {
                    print("error en el json: \(jsonError)")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.loadingView.hideLoadingView()
                    self.mensajeError.showElements()
                    self.mensajeError.showView()
                    self.tableView.isHidden = true
                    
                }
                
                
             
            }
            //aqui poner el sweet alert de error
            
            
        }
        
        
        task.resume()
   
    
    }
    
    
    func foodOrder(operat : Operations){
    
        let reservation_id = reservation.id
        let client_id : Int = prefs.integer(forKey: "ID_CLIENTE") as Int
        let origin_id = 2
        let user_id = 1
        let room_id = reservation.room_id
        let location_id = lugar.1
        let estatus = 1
        let operatId = operat.id
        
        
        loadingView.showMenuLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        
        let postString = "reservations_id=\(reservation_id)&operation_id=\(operatId)&client_id=\(client_id)&origin_id=\(origin_id)&user_id=\(user_id)&location_id=\(location_id)&fecha_orden=\(operat.fecha)&hora_orden=\(operat.hora)&room_id=\(room_id)&estatus=\(estatus)"
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(HttpRuta.ruta)/foodorders")! as URL)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                DispatchQueue.main.async(execute: {
                    self.loadingView.hideLoadingView()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alert = UIAlertController(title: "¡Error!", message:"error interno en el servidor", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                })

                print("error=\(error!)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                
            }else{
            
                do{
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject] {
                        
                        let orderData = json["food_order"] as! [String:AnyObject]
                        
                        let foodOrder = FoodOrder()
                        foodOrder.reservation_id = orderData["reservations_id"] as! String
                        foodOrder.operation_id = orderData["operation_id"] as! String
                        foodOrder.client_id = orderData["client_id"] as! String
                        let origen = orderData["origin_id"] as! String
                        foodOrder.origin_id = Int(origen)!
                        let user_id = orderData["user_id"] as! String
                        foodOrder.user_id = Int(user_id)!
                        let location = orderData["location_id"] as! String
                        foodOrder.location_id = Int(location)!
                        foodOrder.fecha_orden = orderData["fecha_orden"] as! String
                        foodOrder.hora_orden = orderData["hora_orden"] as! String
                        let room = orderData["room_id"] as! String
                        foodOrder.roomId = Int(room)!
                        foodOrder.estatus = orderData["estatus"] as! String
                        foodOrder.updated_at = orderData["updated_at"] as! String
                        foodOrder.created_at = orderData["created_at"] as! String
                        foodOrder.id = orderData["id"] as! Int
                        
                        DispatchQueue.main.async(execute: {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.loadingView.hideLoadingView()
                            self.createArticles(foodOrder: foodOrder)
                            
                        })
                        
                        
                    }
                    
                } catch let jsonError {
                    print("error en el json: \(jsonError)")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.loadingView.hideLoadingView()
                    self.mensajeError.showElements()
                    self.mensajeError.showView()
                    self.tableView.isHidden = true
                    
                }
                
            
            }
    
        
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            print("responseString = \(responseString!)")
            
            
        }
        
        task.resume()
    
    }
    

    
    func createArticles(foodOrder : FoodOrder){
    
        var band = false
        
        print(currentOrder.count)
        
        for x in currentOrder{
            
            let operation_id = foodOrder.operation_id
            let descripcion_producto = x.0.nombre
            let cantidad = x.1.replacingOccurrences(of: "Cant:", with: "")
            let tipo = x.0.tipo
            
            loadingView.showMenuLoad()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
            let request = NSMutableURLRequest(url: NSURL(string: "\(HttpRuta.ruta)/operations/\(operation_id)/details")! as URL)
            request.httpMethod = "POST"
            let postString = "cantidad_prod=\(cantidad)&tipo=\(tipo)&descripcion_prod=\(descripcion_producto)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    band = false
                    DispatchQueue.main.async(execute: {
                        self.loadingView.hideLoadingView()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        let alert = UIAlertController(title: "¡Error!", message:"error interno en el servidor", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    })
                    
                    print("error=\(error!)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                    
                }else{
                
                    band = true
                
                }
                
                
                print(postString)
                
                
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                print("responseString = \(responseString!)")

            }
            task.resume()

        }
        
        
            DispatchQueue.main.async(execute: {
                self.loadingView.hideLoadingView()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.loadingView.hideLoadingView()
                _ = self.sweetAlert.showAlert("Completado!", subTitle: "Su orden de mantenimiento ha sido enviada con exito", style: AlertStyle.success)

            })
        
        

    }
    
    //MARK: METODO PARA CREAR UN DETAIL
    func createDetailOrder(FoodOrder foodOrder : FoodOrder){
        
        var band = true
        
        print(currentOrder.count)
        
        for x in currentOrder{
            
            let operation_id = foodOrder.operation_id
            let descripcion_producto = x.0.nombre
            let cantidad = x.1.replacingOccurrences(of: "Cant:", with: "")
            let tipo = x.0.tipo
            
            loadingView.showMenuLoad()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/operations/\(operation_id)/details/")!)
            
            request.httpMethod = "POST"
            let postString = "cantidad_prod=\(cantidad)&tipo=\(tipo)&descripcion_prod=\(descripcion_producto)"
            
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
                        band = false
                        self.loadingView.hideLoadingView()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        let alert = UIAlertController(title: "¡Error 501!", message:"error interno en el servidor", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    })
                    
                    return
                }
                    
                else{
                    
                    DispatchQueue.main.async(execute: {
                        self.loadingView.hideLoadingView()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.loadingView.hideLoadingView()
                            _ = self.sweetAlert.showAlert("Completado!", subTitle: "Su orden de mantenimiento ha sido enviada con exito", style: AlertStyle.success)
                            
                            let responseString = String(data: data!, encoding: .utf8)
                            print("responseString = \(responseString!)")
                    
                    })
                    print("algo salio mal en details")
                    
                }
                
            }
            
            task.resume()
        
        }
        
        if band == true{
        
            DispatchQueue.main.async(execute: {
              
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.loadingView.hideLoadingView()
                _ = self.sweetAlert.showAlert("Completado!", subTitle: "Su orden de mantenimiento ha sido enviada con exito", style: AlertStyle.success)

            })
        
        }else{
        
            DispatchQueue.main.async(execute: {

                self.loadingView.hideLoadingView()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let alert = UIAlertController(title: "¡Error!", message:"error no se puedo crear la orden", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                }))
                self.present(alert, animated: true, completion: nil)
            })
        
        }
    
    
    }
    
    
    
    
    
    func sweetAlertOkButtonPressed() {
      
        
        let arrayControllers = self.navigationController?.viewControllers
        
        print("entre al delegado de sweet alert")
        
        var vc : ConsumosTableViewController?
        for x in arrayControllers!{
            if x is ConsumosTableViewController{
                vc = x as? ConsumosTableViewController
            }
        
        }
        navigationController?.popToViewController(vc!, animated: true)
        
    }
    

}
