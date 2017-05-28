//
//  ViewController.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 26/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit
import StretchHeader

class HomeViewController: UITableViewController {

    let cellId1 = "cellId1"
    let cellId2 = "cellID2"
    
    var header : StretchHeader!

    let settings: [Setting] = {
        return [Setting(name: "Consumos",imageName : "consumos",color: UIColor.azul(),descripcion: "Revise sus consumos aqui"),Setting(name: "Servicios",imageName : "servicios",color: UIColor.verde(),descripcion:"Informacion de servicios"),Setting(name: "Mantenimientos",imageName : "reservas",color: UIColor.naranjaGarden(),descripcion:"realice ordenes de mantenimiento"),Setting(name: "Galeria",imageName : "servicios",color: UIColor.morado(),descripcion:"conozca nuestras instalaciones")]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        
        //Arreglo de tipo Setting que servira como nuestro dataSource
    
        
        
        //SETTING TABLEVIEW
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        
        tableView.register(HomeTableViewCell1.self, forCellReuseIdentifier: cellId1)
       // tableView.register(HomeTableViewCell2.self, forCellReuseIdentifier: cellId2)
        
       navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"logout")?.withRenderingMode(.alwaysTemplate) , style: .done, target: self, action: #selector(self.logOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        setupHeaderView()

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: TABLEVIEW METHODS DELEGATES
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellId1) as! HomeTableViewCell1
      //  let cell2 = tableView.dequeueReusableCell(withIdentifier: cellId2) as! HomeTableViewCell2
        
        
            cell1.setting = settings[indexPath.row]
            return cell1
            
      
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0...3:
            return 80
            
        default:
            return 60
        }
    }
    
//    
//    //MARK: METODO PARA SETEAR EL HEADER DE LA TABLA
    func setupHeaderView() {
        
        let options = StretchHeaderOptions()
        options.position = .underNavigationBar
        
        header = StretchHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 220),
                                 imageSize: CGSize(width: view.frame.size.width, height: 220),
                                 controller: self,
                                 options: options)
        
        header.imageView.image = UIImage(named: "hotel")
        header.imageView.contentMode = .scaleToFill
        header.imageView.layer.masksToBounds = true
        tableView.tableHeaderView = header
    }
    
    
    // MARK: - ScrollView Delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
        
    }
    
    //MARK: METODO PARA DESLOGUEARSE
    func logOut(){
    
        let alertController = UIAlertController(title: "Logout", message: "¿Esta seguro que desea cerrar sesion?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .destructive) {
            (result : UIAlertAction) -> Void in
            
            let loginVc = LoginViewController()
            
            self.present(loginVc, animated: true, completion: nil)
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



}

