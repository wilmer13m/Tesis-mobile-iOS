//
//  DetailConsumoTableViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 29/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit
import StretchHeader


class DetailConsumoTableViewController: UITableViewController {
    
    //var que traigo de la lista de consumos
    var foodOrder = FoodOrder()
    
    
    let cellId = "cellId"
    
    let loadingView = LoadingView(message: "Cargando")
    let mensajeError = MensajeError(ImageName: "sin_conexion", Titulo: "Oops!", Mensaje: "No hay conexion a internet")
    
    var header : StretchHeader!

    var nombreLugar = String()
    
    var comidasArray = [ArticleList]()
    var postresArray = [ArticleList]()
    var bebidasArray = [ArticleList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SETTING TABLEVIEW
        tableView.register(OrderConsumoTableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupHeaderView()
        
        //SETTING NAVBAR
        navigationItem.title = "Detalle de orden"
        navigationController?.navigationBar.tintColor = .white
        
        
        for x in foodOrder.articles{
        
            print(x.tipo)
            print(x.descripcion_prod)
            switch x.tipo {
            case 1:
                comidasArray.append(x)
            break
                
            case 2:
                bebidasArray.append(x)

            break
            default:
                postresArray.append(x)
                break
            }
            
        }
        
        
        location(idLocation: foodOrder.location_id)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Comidas"
            
        case 1:
            
            return "Bebidas"
        
        case 2:
            
            return "Postres"
        
        case 3:
            
            return "Lugar"
            
        default:
            return "Fecha"
        }
        
    }
    
    
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
            
            cell.titleLabel.text = comidasArray[indexPath.row].descripcion_prod
            cell.cantidadLabel.text = "\(comidasArray[indexPath.row].cantidad_prod)"
            break
            
        case 1:
            cell.titleLabel.text = bebidasArray[indexPath.row].descripcion_prod
            cell.cantidadLabel.text = "\(bebidasArray[indexPath.row].cantidad_prod)"
            break
            
        case 2:
            cell.titleLabel.text = postresArray[indexPath.row].descripcion_prod
            cell.cantidadLabel.text = "\(postresArray[indexPath.row].cantidad_prod)"
            
        case 3:
            cell.titleLabel.text = nombreLugar
            cell.cantidadLabel.text = " "
        default:
            cell.titleLabel.text = foodOrder.created_at
            cell.cantidadLabel.text = " "
        }
        
        return cell

    }
    
    
  

    func location(idLocation id : Int){
    
        print("entre al fetching")
        
     //   mensajeError.hideElements()
        loadingView.showMenuLoad()
        
        
        let url = URL(string: "\(HttpRuta.ruta)/locations/\(id)")
        
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
                    
                    
                    print(json.count)
                    
                    let locationData = json["location"] as! [String:AnyObject]
                    
                    self.nombreLugar = locationData["nombre"] as! String
                    
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
    
    
    
    
    
    func reloadData(){
        location(idLocation: foodOrder.location_id)
        
    }
 

}
