//
//  helpers.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 27/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import Foundation
import UIKit


extension UIColor{
    
    //METODO QUE REGRESA UN COLOR SEGUN SU CODIGO RGB
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha:   1)
        
    }
    
    
    static func naranjaGarden()->UIColor {
        
        return rgb(236, green: 78, blue: 27)
        
    }
    
    static func separatorCell() -> UIColor{
        
        return UIColor.rgb(230, green: 230, blue: 230)
        
    }

    
    static func azul() -> UIColor{
        
        return UIColor.rgb(28, green: 164, blue: 247)
    }
    
    static func verde() -> UIColor{
        
        return UIColor.rgb(53, green: 178, blue: 7)
    }

    static func morado() -> UIColor{
        
        return UIColor.rgb(187, green: 8, blue: 236)
    }
    
    static func anaranjadoEditar() -> UIColor{

        return UIColor.rgb(230, green: 126, blue: 34)
    
    }
    
}



extension UIView{
    
    func addConstraintWithFormat(_ format : String, views : UIView...){
        
        var viewsDitcionary = [String : UIView]()
        
        for(index, view) in views.enumerated(){
            let key = "v\(index)"
            
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDitcionary[key] = view
            
        }
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDitcionary ))
        
    }
    
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    
}



extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}



extension String {


    func reemplazarEspaciosEnBlancoPorBarra() -> String{
        
        let x = self
        
        var nuevaCadena = String()
        
        for char in x.characters{
            
            if char == " "{
                
                let replace = " | "
                
                nuevaCadena = nuevaCadena + String(replace)
                
            }
                
            else{
                
                nuevaCadena = nuevaCadena + String(char)
                
            }
            
        }
        
        return nuevaCadena
        
    }

    func reemplazarEspaciosEnBlancoPorTexto() -> String{
        
        let x = self
        
        var nuevaCadena = String()
        
        for char in x.characters{
            
            if char == " "{
                
                let replace = " a las "
                
                nuevaCadena = nuevaCadena + String(replace)
                
            }
                
            else{
                
                nuevaCadena = nuevaCadena + String(char)
                
            }
            
        }
        
        return nuevaCadena
        
    }

    
    func reemplazarGuionesPorSlash() -> String{
        
        let x = self
        
        var nuevaCadena = String()
        
        for char in x.characters{
            
            if char == "-"{
                
                let replace = "/"
                
                nuevaCadena = nuevaCadena + String(replace)
                
            }
                
            else{
                
                nuevaCadena = nuevaCadena + String(char)
                
            }
            
        }
        
        return nuevaCadena
        
    }


}




class HttpRuta {


    static var ruta = "http:localhost:8000/api"

}


class ActionSteeper: UIStepper {
    var touchUpInside: ((_ steeper: UIStepper) -> ())?
 
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:)") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSteeper()
    }
    
    func setupSteeper() {
        //this is my most common setup, but you can customize to your liking
        addTarget(self, action: #selector(touchUpInside(sender:)), for: .touchUpInside)
    }
    
    //actions
    func touchUpInside(sender: UIStepper) {
        touchUpInside?(sender)
    }
    
}




