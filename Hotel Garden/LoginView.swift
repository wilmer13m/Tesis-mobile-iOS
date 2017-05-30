//
//  LoginView.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 27/5/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class LoginView: UIView {

  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        
        self.backgroundColor = .azul()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let backGroundImage : UIImageView = {
        
        let image = UIImageView()
        image.image = UIImage(named: "entrada")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.addBlurEffect()
        return image
    
    }()
    
    let logoImageView : UIImageView = {
    
        let image = UIImageView()
        image.image = UIImage(named: "logo_web")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    
    }()
    
    let userTextField : UITextField = {
    
        let textField = UITextField()
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.clear
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        textField.leftViewMode = UITextFieldViewMode.always
        textField.attributedPlaceholder = NSAttributedString(string: "Usuario",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])

        
        let image = UIImageView(image: UIImage(named: "user")?.withRenderingMode(.alwaysTemplate))
        image.tintColor = UIColor.white
        if let size = image.image?.size {
            image.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 20.0, height: size.height)
        }
        image.contentMode = UIViewContentMode.center
        textField.leftView = image
        textField.leftViewMode = UITextFieldViewMode.always
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1

        return textField
    }()
    
    let passwordTextfield : UITextField = {
        
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "Contraseña",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.clear
        textField.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.returnKeyType = .done

        let image = UIImageView(image: UIImage(named: "password")?.withRenderingMode(.alwaysTemplate))
        image.tintColor = UIColor.white
        if let size = image.image?.size {
            image.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 20.0, height: size.height)
        }
        image.contentMode = UIViewContentMode.center
        textField.leftView = image
        textField.leftViewMode = UITextFieldViewMode.always
        
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1

        
        return textField
    }()
    
    let loginButton : UIButton = {
    
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ingresar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
        button.backgroundColor = .naranjaGarden()
        button.layer.cornerRadius = 5
        return button
    }()
    


    func setupViews(){
        
        addSubview(backGroundImage)
        addSubview(logoImageView)
        addSubview(userTextField)
        addSubview(passwordTextfield)
        addSubview(loginButton)
        
        
        addConstraintWithFormat("H:|[v0]|", views: backGroundImage)
        addConstraintWithFormat("V:|[v0]|", views: backGroundImage)


        addConstraint(NSLayoutConstraint(item: userTextField, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: userTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: userTextField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10))
        addConstraint(NSLayoutConstraint(item: userTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 55))
        
        addConstraint(NSLayoutConstraint(item: passwordTextfield, attribute: .top, relatedBy: .equal, toItem: userTextField, attribute: .bottom, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: passwordTextfield, attribute: .leading, relatedBy: .equal, toItem: userTextField, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: passwordTextfield, attribute: .trailing, relatedBy: .equal, toItem: userTextField, attribute: .trailing, multiplier: 1, constant: 0))
               addConstraint(NSLayoutConstraint(item: passwordTextfield, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 55))
        
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: userTextField, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: passwordTextfield, attribute: .bottom, multiplier: 1, constant: 30))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .leading, relatedBy: .equal, toItem: userTextField, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .trailing, relatedBy: .equal, toItem: userTextField, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 55))
        
        addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .bottom, relatedBy: .equal, toItem: userTextField, attribute: .top, multiplier: 1, constant: -15))
        addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 140))
        addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 70))
        addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -70))
    
    
    }
    
    

}
