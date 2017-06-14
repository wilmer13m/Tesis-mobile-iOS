//
//  FormularioConsumoTableViewCell.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 13/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class FormularioConsumoTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        selectionStyle = .blue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    let titleLabel : UILabel = {
    
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Coca-cola"
        label.clipsToBounds = true
        return label
    }()
    
    
    let mySteeper : ActionSteeper = {
    
        let steeper = ActionSteeper()
        steeper.minimumValue = 0
        steeper.maximumValue = 99
        steeper.translatesAutoresizingMaskIntoConstraints = false
        steeper.clipsToBounds = true
        steeper.wraps = true
        steeper.autorepeat = true
        steeper.tintColor = UIColor.azul()
        return steeper
    }()
    
    
    let cantidadLabel : UILabel = {
    
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Cant: 0"
        return label
    
    }()
    
    
    func setupView(){
        
        addSubview(titleLabel)
        addSubview(mySteeper)
        addSubview(cantidadLabel)
        
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 45))
        
        addConstraint(NSLayoutConstraint(item: cantidadLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 2))
        addConstraint(NSLayoutConstraint(item: cantidadLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 1))
        
        addConstraint(NSLayoutConstraint(item: mySteeper, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10))
        addConstraint(NSLayoutConstraint(item: mySteeper, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    
    
    
    }
    
    
    
}
