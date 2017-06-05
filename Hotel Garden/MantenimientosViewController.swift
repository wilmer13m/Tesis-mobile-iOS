//
//  MantenimientosViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 28/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class MantenimientosViewController: UITableViewController {

    let cellId = "cellId"
    
    let prefs:UserDefaults = UserDefaults.standard
    
    var solicitudes : [Solicitud]?
    
    let loadingView = LoadingView(message: "Cargando")
    
    let mensajeError = MensajeError(ImageName: "sin_conexion", Titulo: "Oops!", Mensaje: "No hay conexion a internet")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        
        //SETTING TABLEVIEW
        tableView.register(MantenimientoTableViewCell.self, forCellReuseIdentifier: cellId)
        
        //SETTING NAVIGATIONBAR
        navigationItem.title = "Mantenimientos"
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(crearMantenimiento))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atras", style:UIBarButtonItemStyle.plain, target: nil, action: nil)

        
        //FETCHING DATA
        fetchingMantenimientos()
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        mensajeError.hideElements()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:METODOS DEL TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solicitudes?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MantenimientoTableViewCell
        
        cell.solicitud = solicitudes?[indexPath.row]
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
       
        let borrar = UITableViewRowAction(style: .normal, title: "Borrar") { action, index in
            print("borrar button tapped")
            
        }
        
        
        borrar.backgroundColor = .red
        
        
        let editar = UITableViewRowAction(style: .normal, title: "Editar") { action, index in
            print("favorite button tapped")
        }
        editar.backgroundColor = .orange
        
        
        return [borrar,editar]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK:METODO PARA CREAR UNA NUEVA ORDEN DE MANTENIMIENTO
    func crearMantenimiento(){
        
        let crearMantenimiento = CreateMantenimientoViewController(style: .plain)
        
        navigationController?.pushViewController(crearMantenimiento, animated: true)
        
    
    }
    
    
    //MARK:METODO PARA EL FETCHING DE MANTENIMIENTOS
    func fetchingMantenimientos(){
    
            print("entre al fetching")
        
            mensajeError.hideElements()
            loadingView.showMenuLoad()
        
            let clientId : Int = prefs.integer(forKey: "ID_CLIENTE") as Int
            
            let url = URL(string: "http://localhost:8000/api/clients/\(clientId)/solicitudes")

            
            print("este es el id del cliente\(clientId)")
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            
            URLSession.shared.dataTask(with: url!) {(data, response, error) in
                
                guard data != nil else {
                    print("error de data: \(error!)")
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.loadingView.hideLoadingView()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Por favor revise su conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                            
                            
                            if self.solicitudes?.count == nil{
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
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [[String:Any]] {
                        
                   //     print(json)
                        
                        self.solicitudes = [Solicitud]()
                     
                        print(json.count)
                        
                        for x in json{
                            
                            let solicitud = Solicitud()
                           
                            
                            solicitud.id = x["id"] as! Int
                            solicitud.client_id = x["client_id"] as! Int
                            solicitud.created_at = x["created_at"] as! String
                            solicitud.estatus = x["estatus"] as! String
                            solicitud.location_id = x["location_id"] as! Int
                            solicitud.updated_at = x["updated_at"] as! String
                            solicitud.descripcion = x["descripcion"] as! String
                            
                            self.solicitudes?.append(solicitud)
                        
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
    
        fetchingMantenimientos()
        print("hola toque el reload")
    }
    
 
}
