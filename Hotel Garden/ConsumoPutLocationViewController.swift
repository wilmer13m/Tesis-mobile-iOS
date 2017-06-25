//
//  ConsumoPutLocationViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 21/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class ConsumoPutLocationViewController: UITableViewController {

    let cellId = "cellId"
    
    //var que traigo del controlador anterior
    var currentOrder = [(Product,String)]()
    var foodOrder = FoodOrder()

    
    let loadingView = LoadingView(message: "Cargando")
    let mensajeError = MensajeError(ImageName: "sin_conexion", Titulo: "Oops!", Mensaje: "No hay conexion a internet")
    
    let locations = [("Piscina",1),("Habitacion",2),("Restaurant",5)]
    var lugar = (String(),Int())
    var aux = 0
    let reservacion = Reservation()
    
    let prefs:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //SETTING TABLEVIEW
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.bounces = false
                
        //SETTING NAVBAR
        navigationItem.title = "Editando orden(4/4)"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"arrow"), style: .plain, target: self, action: #selector(self.siguiente))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atras", style:UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let id_client:Int = prefs.integer(forKey: "ID_CLIENTE") as Int
        fetchingReservation(clientId: id_client)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: METODO DEL TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        cell?.selectionStyle = .blue //Or make label red
        cell?.textLabel?.text = locations[indexPath.row].0
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Lugar de despacho para la orden"
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hola")
        aux = 1
        lugar = locations[indexPath.row]
        print(lugar)
        
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
            if  foodOrder.location_id == locations[indexPath.row].1{
                cell.accessoryType = .checkmark
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            }
        
    }
    
    
    //MARK: METODO PARA TRAER LA DATA DE LA RESERVATION
    func fetchingReservation(clientId id : Int){
        
        print("entre al fetching")
        
        mensajeError.hideElements()
        loadingView.showMenuLoad()
        
        
        let url = URL(string: "\(HttpRuta.ruta)/clients/\(id)/reservations")
        
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
                        
                        //run your function here
                        
                        self.mensajeError.showElements()
                        self.mensajeError.showView()
                        self.mensajeError.reloadButton.addTarget(self, action: #selector(self.reloadData), for: .touchDown)
                        self.tableView.isHidden = true
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                })
                
                return
                
            }
            
            
            do{
                
                if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject] {
                    
                    
                    let  dataReservacion = json["reservacion"] as! [[String:AnyObject]]
                    
                    for x in dataReservacion{
                        self.reservacion.id = x["id"] as! Int
                        self.reservacion.room_id = x["room_id"] as! Int
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
    
    
    func reloadData(){
    
        let id_client:Int = prefs.integer(forKey: "ID_CLIENTE") as Int
        fetchingReservation(clientId: id_client)
    
    }
    
    
    func siguiente(){
        
        var band = Bool()
        
        for food in foodOrder.articles{
            
            for x in currentOrder{
                
                if food.descripcion_prod == x.0.nombre{
                    print("entre al primer if")
                    
                    print(x.1.replacingOccurrences(of: "Cant:", with: ""))
                    print(food.cantidad_prod)
                    
                    if " \(food.cantidad_prod)" != x.1.replacingOccurrences(of: "Cant:", with: "") {
                        print("entre al segundo if")
                        
                        if band == false{
                            band = true
                            
                        }

                    }
                    
                }
                
            }
            
        }
        
        
        if aux == 1{
            
            band = true
        
        }
        
        
        if band == false{
            
            
            let alert = UIAlertController(title: "Error", message:"Debe al menos haber modificado un articulo o agregado uno", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)

        }else{
        
            let putConsumoConsumoVc = PutConsumoViewController(style: .grouped)
            putConsumoConsumoVc.currentOrder = currentOrder
            putConsumoConsumoVc.foodOrder = foodOrder
            putConsumoConsumoVc.lugar = lugar

            navigationController?.pushViewController(putConsumoConsumoVc, animated: true)
        
        }
    }
}
