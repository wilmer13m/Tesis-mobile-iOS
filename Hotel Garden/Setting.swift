//
//  Setting.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 27/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

//Clase que ayudara a crear los elementos que tendra el menu de opciones al darle al boton more
class Setting: NSObject {
    
    var name : String
    
    var imageName : String
    
    var color : UIColor
    
    var descripcion : String
    
    init(name : String, imageName : String, color : UIColor, descripcion : String) {
        
        self.name = name
        self.imageName = imageName
        self.color = color
        self.descripcion = descripcion
    }
    
    
}

