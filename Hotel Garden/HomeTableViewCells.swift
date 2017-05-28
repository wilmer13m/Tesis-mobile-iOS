//
//  HomeTableViewCells.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 27/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit
import Foundation

//CELDA QUE SE USA PARA LAS 3 PRIMERAS CELDAS DE LA TABLA
class HomeTableViewCell1: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none // para que no se vea el el color gris cuando se seleccione esa celda
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var setting : Setting? {
        
        didSet{
            
            if let imageName = setting?.imageName{
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) //esto sirve para que el color cambie
                iconImageView.tintColor = UIColor.white//setenadole por default el color blanco
            }
            
            circleView.backgroundColor = setting?.color
        }
        
    }
    
    let circleView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 20
        return view
    
    }()
    
    let iconImageView : UIImageView = {
        
        let icon = UIImageView()
        icon.image = UIImage(named: "")
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 10
        icon.contentMode = .scaleAspectFit
     //   icon.backgroundColor = UIColor.red
        
        return icon
    }()
    
    
    let labelTitulo : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 3
        
        let attributedText = NSMutableAttributedString(string: "Consumos", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSMutableAttributedString(string:"\n podra ver todos sus consumos aqui", attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.black]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.characters.count))
        
//        let attachment = NSTextAttachment()
//        attachment.image = UIImage(named: "global")
//        attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
//        attributedText.append(NSAttributedString(attachment: attachment))
        
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.separatorCell()
        return view
    
    }()
    
    
    
    func setupViews(){
        
        addSubview(circleView)
        circleView.addSubview(iconImageView)
        //addSubview(iconImageView)
        addSubview(labelTitulo)
        addSubview(separatorView)
        
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: circleView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: circleView, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
         addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        
        addConstraint(NSLayoutConstraint(item: labelTitulo, attribute: .centerY, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: labelTitulo, attribute: .leading, relatedBy: .equal, toItem: iconImageView, attribute: .trailing, multiplier: 1, constant: 20))
        
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))

        
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: separatorView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
    }
    
}



//CLDA QUE SE USA PARA LA CELDA DE CONFIGURACIONES

class HomeTableViewCell2: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none // para que no se vea el el color gris cuando se seleccione esa celda
        self.backgroundColor = UIColor(white: 0.95, alpha: 1)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let iconImageView : UIImageView = {
        
        let icon = UIImageView()
        icon.image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = UIColor.rgb(89, green: 87, blue: 80)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFill
        
        return icon
        
    }()
    
    func setupViews(){
        
        addSubview(iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        
        
        
    }
    
    
}
