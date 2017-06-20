//
//  ConsumoLocationViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 19/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class ConsumoLocationViewController: UITableViewController {

    
    //var que traigo del controlador anterior
    var currentOrder = [(Product,String)]()
    

    
    let cellId = "cellId"
    
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
        navigationItem.title = "Nueva orden(4/4)"
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
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark

    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none

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
    
    
    func siguiente(){
    
        if currentOrder.count == 0 || aux == 0{
            
            
            let alert = UIAlertController(title: "Error", message:"Debe al menos haber seleccionado un articulo para continuar", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
            
            for x in currentOrder{
                
                print("\(x.0.nombre) \(x.1)")
                
            }
            
            let previewOrdenConsumoVc = PreviewOrdenConsumoViewController(style: .grouped)
            previewOrdenConsumoVc.currentOrder = currentOrder
            previewOrdenConsumoVc.reservation = reservacion
            previewOrdenConsumoVc.lugar = lugar
            navigationController?.pushViewController(previewOrdenConsumoVc, animated: true)
            
        }
    
    
    }
    
    
    
    func reloadData(){
    
        fetchingReservation(clientId: 1)
    
    }

}
