//
//  LoginViewModel.swift
//  WoocoTestProject
//
//  Created by Sepehr Rezaei on 12/12/21.
//

import Foundation
import UIKit

class LoginViewModel : NSObject {
    
    func saveKeysInUserDefualt (key: String, secret: String) {
        let userdefaults = UserDefaults.init()
        userdefaults.set(key, forKey: Strings.CONSUMER_KEY)
        userdefaults.set(secret, forKey: Strings.CONSUMER_SECRET)
    }
    
}
