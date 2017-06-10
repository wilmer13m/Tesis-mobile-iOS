//
//  MantenimientoTableViewCell.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 4/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class MantenimientoTableViewCell: UITableViewCell {
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupViews()
            selectionStyle = .none // para que no se vea el el color gris cuando se seleccione esa celda
    }
    
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
        
    
    var solicitud : Solicitud?{
        
        didSet{
            
            detailLabel.text = solicitud?.descripcion
            
            //Llenando el label date
            if solicitud?.created_at != solicitud?.updated_at{
                
                let date = solicitud?.created_at.reemplazarEspaciosEnBlancoPorBarra().reemplazarGuionesPorSlash()
                dateLabel.text = date
                
            }else{
                
                let date = solicitud?.created_at.reemplazarEspaciosEnBlancoPorBarra().reemplazarGuionesPorSlash()
                dateLabel.text = date
            }
            
            //asginando el label title
            titleLabel.text = solicitud?.estatus
            
            if let status = solicitud?.estatus{
                
                switch status {
                case "Por procesar":
                    
                    statusCircle.backgroundColor = .azul()
                    break
                    
                case "Procesando":
                    
                    statusCircle.backgroundColor = .yellow
                    break
                    
                case "Cancelada":
                    
                    statusCircle.backgroundColor = .red
                    
                default:
                    
                    statusCircle.backgroundColor = .green
                    break
                }
            
            }
            
        }
        
    }
    
    let circleView : UIView = {
            
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.naranjaGarden()
        view.layer.cornerRadius = 20
        return view
            
    }()
    
    let statusCircle : UIView = {
    
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 7
        circle.backgroundColor = .red
        return circle
    }()
        
    let iconImageView : UIImageView = {
            
        let icon = UIImageView()
        icon.image = UIImage(named: "reservas")?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = UIColor.white
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 10
        icon.contentMode = .scaleAspectFit
        //   icon.backgroundColor = UIColor.red
        
        return icon
    }()
        
        
    let titleLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Parrilla"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()
        
        
    let detailLabel : UILabel = {
            
        let label = UILabel()
        label.text = "parrilla mar y tierra para 2 personas especial de la casa con vino incluido, para las 08:00pm..."
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.rgb(155, green: 161, blue: 171)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
            
    }()
        
        
    let dateLabel : UILabel = {
            
        let label = UILabel()
        label.text = "18/03/17 05:00"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.rgb(155, green: 161, blue: 171)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()
        
  
        
        
    func setupViews(){
            
            
        addSubview(circleView)
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(dateLabel)
        addSubview(statusCircle)
            

        
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
            
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: circleView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: circleView, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
            
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: circleView, attribute: .trailing, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: detailLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: detailLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: detailLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -35))
        
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -5))
        
        addConstraint(NSLayoutConstraint(item: statusCircle, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10))
         addConstraint(NSLayoutConstraint(item: statusCircle, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: statusCircle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 14))
        addConstraint(NSLayoutConstraint(item: statusCircle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 14))
        
            
    }
    
}
