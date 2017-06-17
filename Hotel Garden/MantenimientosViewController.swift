//
//  MantenimientosViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 28/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class MantenimientosViewController: UITableViewController,CrearServicioDelegate {

    let cellId = "cellId"
    
    let prefs:UserDefaults = UserDefaults.standard
    
    var solicitudes : [Solicitud]?
    
    let loadingView = LoadingView(message: "Cargando")
    
    let mensajeError = MensajeError(ImageName: "sin_conexion", Titulo: "Oops!", Mensaje: "No hay conexion a internet")

    var bandera = Int()
    
    var crearMantenimientoVc = CreateServicioViewController(style: .plain)
    var editarMantenimientoVc = EditServicioViewController(style: .plain)
    var locations : [Location]?
    
    var dscr = String()
    var id = Int()
    var lugarId = Int()
    
    var sweetAlert = SweetAlert()
    
    lazy var refreshControl1: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "pull to refresh")
        refreshControl.addTarget(self, action: #selector(MantenimientosViewController.handleRefresh(refreshControl:)), for: .valueChanged)
        return refreshControl
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchingMantenimientos()
        

        
        if ((solicitudes?.count) != nil){
            let index = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: index, at: .top, animated: true)
        }
        
         dscr = String()
         id = Int()
         lugarId = Int()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        crearMantenimientoVc.crearMantDelegate = self
        
        //SETTING TABLEVIEW
        tableView.register(ServicioTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.addSubview(refreshControl1)
        
        
        //SETTING NAVIGATIONBAR
        navigationItem.title = "Mantenimientos"
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(crearMantenimiento))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atras", style:UIBarButtonItemStyle.plain, target: nil, action: nil)

        
//        //FETCHING DATA
//        fetchingMantenimientos()
        
        

        
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
    
    
    //MARK:METODOS DEL TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solicitudes?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ServicioTableViewCell
        
        
     //   cell.solicitud = solicitudes?.reversed()[indexPath.row]
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
       

        let borrar = UITableViewRowAction(style: .normal, title: "Borrar") { action, index in
            print("borrar button tapped")
            
            let status = self.solicitudes!.reversed()[index.row].estatus
            let idSolicitud = self.solicitudes!.reversed()[index.row].id
            
            if status != "Por procesar"{
                
                DispatchQueue.main.async(execute: {
                    
                    let alert = UIAlertController(title: "¡Error!", message:"las ordenes con estatus: '\(status)' no pueden ser eliminadas", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
                        
                    }))
                    
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                })
                
            }else{
            
                print("pase la verificacion")
                
                DispatchQueue.main.async(execute: {
                    
                    let alert = UIAlertController(title: "¡Atencion!", message:"¿Esta seguro que desea borrar esta orden?", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.destructive, handler:  { action in
                        
                        self.deleteMantenimiento(id: idSolicitud)
                        
                    }))
                    
                    
                    alert.addAction(UIAlertAction(title: "Cancel" , style: UIAlertActionStyle.cancel, handler:  { action in
                        
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                })
            
            
            }

        }
        
        borrar.backgroundColor = UIColor.rgb(231, green: 76, blue: 60)
        
    
        
        let editar = UITableViewRowAction(style: .normal, title: "Editar") { action, index in
            print("editar button tapped")
            
            print(index.row)
            
            let status = self.solicitudes!.reversed()[index.row].estatus
            
            print(status)
            
            if status != "Por procesar"{
            
                DispatchQueue.main.async(execute: {
                    
                    let alert = UIAlertController(title: "¡Error!", message:"las ordenes con estatus: '\(status)' no pueden ser modificadas", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
                     
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                })
                
            }else{
                
                 self.dscr = self.solicitudes!.reversed()[index.row].descripcion
                 self.lugarId = self.solicitudes!.reversed()[index.row].location_id
                 self.id = self.solicitudes!.reversed()[index.row].id
                
                print("la descripcion es:\(self.dscr) y el lugar es: \(self.lugarId)")
                
                self.editarMantenimientoVc.descrip = self.dscr
                self.editarMantenimientoVc.lugarId = self.lugarId
                self.editarMantenimientoVc.idSolicitud = self.id
                
                self.navigationController?.pushViewController(self.editarMantenimientoVc, animated: true)
            
            }
            
            
            
            
        }
        
        editar.backgroundColor = .azul()
        
        
        return [borrar,editar]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK:METODO PARA CREAR UNA NUEVA ORDEN DE MANTENIMIENTO
    func crearMantenimiento(){
        
        navigationController?.pushViewController(crearMantenimientoVc, animated: true)
        
    }
    
    
    //MARK:METODO PARA EL FETCHING DE MANTENIMIENTOS
    func fetchingMantenimientos(){
    
            print("entre al fetching")
        
            mensajeError.hideElements()
            loadingView.showMenuLoad()
        
            let clientId : Int = prefs.integer(forKey: "ID_CLIENTE") as Int
            
            let url = URL(string: "\(HttpRuta.ruta)/clients/\(clientId)/solicitudes")

            print(url!)
        
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
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject] {
                        
                   //     print(json)
                        
                        self.solicitudes = [Solicitud]()
                        
                     
                        print(json.count)
                        
                        let solicitudesArray = json["solicitudes"] as? [[String:AnyObject]]
                        
                        if let solicitudes = solicitudesArray {
                            
                            for x in solicitudes{
                                
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
    
    //MARK: LLAMANDO AL DELEGADO
    func pasarDataDelegate(x: Int){
        
        if x == 1{
            
            fetchingMantenimientos()
            
        }
        
    }
    
    
    //MARK:METODO PARA RECARGAR LA DATA
    func reloadData(){
    
        fetchingMantenimientos()
        print("hola toque el reload")
    }
    
    
    
    //MARK:FETCHING LOCATIONS
    func fetchingLocations(){
        
        print("entre al fetching")
        
        mensajeError.hideElements()
        loadingView.showMenuLoad()
        
        
        let url = URL(string: "\(HttpRuta.ruta)/locations")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard data != nil else {
                print("error de data: \(error!)")
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingView.hideLoadingView()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Por favor revise su conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
                        
                        if self.locations?.count == nil{
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
                    
                    self.locations = [Location]()
                    
                    print(json.count)
                    
                    for x in json{
                        
                        let location = Location()
                        
                        
                        location.id = x["id"] as! Int
                        location.nombre = x["nombre"] as! String
                        location.descripcion = x["descripcion"] as! String
                        
                        self.locations?.append(location)
                        
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
    
    
    //MARK:METODO PARA BORRAR LOGICAMENTE EL MANTENIMIENTO SELECCIONADO
    func deleteMantenimiento(id : Int){
    
        let clientId : Int = prefs.integer(forKey: "ID_CLIENTE") as Int
        
        loadingView.showMenuLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        var request = URLRequest(url: URL(string: "\(HttpRuta.ruta)/clients/\(clientId)/solicitudes/\(id)")!)

        
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
                self.fetchingMantenimientos()
            })
            
            
            //aqui poner el sweet alert de error
        }
        
        task.resume()
    
    
    }
    
    
    //MARK: METODO QUE SE USA PARA RECARGAR LA TABLA CUANDO SE HACE PULLDOWN
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.solicitudes = nil
        //pag = 1
        //cont = 0
        fetchingMantenimientos()
        refreshControl.endRefreshing()
    }

 
}
