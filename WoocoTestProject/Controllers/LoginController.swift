//
//  LoginController.swift
//  WoocoTestProject
//
//  Created by Sepehr Rezaei on 12/12/21.
//

import UIKit

class LoginController: UIViewController {
    
    private var loginViewModel : LoginViewModel!
    
    @IBOutlet weak var nameTextF : UITextField!
    @IBOutlet weak var emailTextF : UITextField!
    @IBOutlet weak var websiteTextF : UITextField!
    @IBOutlet weak var consumerKeyTextF : UITextField!
    @IBOutlet weak var consumersecretTextF : UITextField!
    @IBOutlet weak var loginBtn : UIButton!
    @IBOutlet weak var stackView : UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel()
        self.loginBtn.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        self.loginBtn.removeTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        
        if self.consumerKeyTextF.text == "" || self.consumersecretTextF.text == "" {
            return
        }
        
        loginBtn.configuration?.showsActivityIndicator = true
        
        // imp : because lack of time and donot have access to firebase documentation because of vpn i changed firebase auth to userdefuelts
        loginViewModel.saveKeysInUserDefualt(key: self.consumerKeyTextF.text!, secret: self.consumersecretTextF.text!)
        
        loginBtn.configuration?.showsActivityIndicator = false
        
        // go to product page
        DispatchQueue.main.async {
            guard let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Strings.ProductPageIdentifier) as? ProductListController else {return}
            initialViewController.modalPresentationStyle = .fullScreen
            initialViewController.modalTransitionStyle = .flipHorizontal
            self.present(initialViewController, animated: true, completion: nil)
        }
    }
    
    
}
