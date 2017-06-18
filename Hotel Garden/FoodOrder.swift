//
//  FoodOrder.swift
//  Hotel Garden
//
//  Created by Wilmer Mendoza on 17/6/17.
//  Copyright © 2017 Wilmer Mendoza. All rights reserved.
//

import UIKit

class FoodOrder: NSObject {
    
    var id = Int()
    var reservation_id = Int()
    var client_id = Int()
    var user_id = Int()
    var roomId = Int()
    var location_id = Int()
    var origin_id = Int()
    var estatus = String()
    var created_at = String()
    var updated_at = String()
    var details = [Detail]()
        
}
