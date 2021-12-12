//
//  ViewController.swift
//  WoocoTestProject
//
//  Created by Sepehr Rezaei on 12/12/21.
//

import UIKit

class ViewController: UIViewController {
    // splash activity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add image
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            if UserDefaults.init().string(forKey: Strings.CONSUMER_KEY) != nil {
                // login
                guard let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Strings.ProductPageIdentifier) as? ProductListController else {return}
                initialViewController.modalPresentationStyle = .fullScreen
                initialViewController.modalTransitionStyle = .flipHorizontal
                self.present(initialViewController, animated: true, completion: nil)
            }
            else{
                // no login
                guard let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Strings.LoginPageIdentifier) as? LoginController else {return}
                initialViewController.modalPresentationStyle = .fullScreen
                initialViewController.modalTransitionStyle = .flipHorizontal
                self.present(initialViewController, animated: true, completion: nil)
            }
        })
        
    }


}

