//
//  DetailServiciosViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 14/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit
import StretchHeader


class DetailServiciosViewController: UITableViewController {

    var solicitud = Solicitud()
    
    
    let mensajeError = MensajeError(ImageName: "sin_conexion", Titulo: "Oops!", Mensaje: "No hay conexion a internet")
    let loadingView = LoadingView(message: "Cargando...")
    
    var location = Location()

    
    let cellId = "cellId"
    var header : StretchHeader!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaderView()
        fetchingLocation()
        
        //SETTING TABLEvIEW
        tableView.register(DetailServicioTableViewCell.self, forCellReuseIdentifier: cellId)
        
        //SETTING NAVBAR
        navigationItem.title = "Detalle de orden"
        navigationController?.navigationBar.tintColor = .white

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        header.imageView.image = UIImage(named: "servicio")
        header.imageView.contentMode = .scaleToFill
        header.imageView.layer.masksToBounds = true
        tableView.tableHeaderView = header
    }
    
    
    // MARK: - ScrollView Delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
        
    }
    
    
    //MARK:METODOS DEL TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Detalle de orden"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 1:
            
            return 90
            
        default:
           return 60
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! DetailServicioTableViewCell
        
        switch indexPath.row {
        case 0:
            
            cell.titleLabel.text = "Lugar:"
            cell.descripLabel.text = location.nombre
            break
        case 1:
            
            cell.titleLabel.text = "Descripcion:"
            cell.descripLabel.text = solicitud.descripcion
            break
        case 2:
            
            cell.titleLabel.text = "Estatus:"
            cell.descripLabel.text = solicitud.estatus
            break
        default:
            
            cell.titleLabel.text = "Fecha:"
            cell.descripLabel.text = solicitud.updated_at.reemplazarGuionesPorSlash().reemplazarEspaciosEnBlancoPorTexto()
            break
        }
        
        
        return cell
        
    }
    

    
    
    
    //MARK:FETCHING LOCATIONS
    func fetchingLocation(){
        
        print("entre al fetching")
        
        mensajeError.hideElements()
        loadingView.showMenuLoad()
        
        
        let url = URL(string: "\(HttpRuta.ruta)/locations/\(solicitud.location_id)")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard data != nil else {
                print("error de data: \(error!)")
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingView.hideLoadingView()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alert = UIAlertController(title: "¡Ha ocurrido un error!", message:"Por favor revise su conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok" , style: UIAlertActionStyle.default, handler:  { action in
                        
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
                
                if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:Any] {
                    
                    //     print(json)
                    

                    let dataLocation = json["location"] as! [String:AnyObject]
                    
                    self.location.nombre = dataLocation["nombre"] as! String
                    self.location.descripcion = dataLocation["descripcion"] as! String
                    
        
                    
                    //recargo la data del collectionView de manera asincrona
                    DispatchQueue.main.async(execute: {
                        
                        let indexPaths = NSIndexPath(item: 0, section: 0)
                        self.tableView.reloadRows(at: [indexPaths as IndexPath], with: .none)

//                        self.tableView.reloadData()
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
        
        fetchingLocation()
    
    }

}
