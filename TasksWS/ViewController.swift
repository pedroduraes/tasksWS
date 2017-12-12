//
//  ViewController.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 06/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtUser: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtPassword.text = "Scopus123"
        txtUser.text = "pedro.martins.duraes@gmail.com"
        IsFirstRun()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        trylogin()
    }
    
    func IsFirstRun()  {
        let userStand = UserDefaults.standard
        if !userStand.bool(forKey: Constants.FirstRun) {
            //e a primeira vez que rodou
            userStand.set(true, forKey: Constants.FirstRun)
            KeyChain.clearAll()
        }
    }
    
    func trylogin()  {
        var logou : Login?
        showProgress()
        PostService().login(username: txtUser.text! , password: txtPassword.text! , onSuccess: { response in
            logou = response?.body
            UserDefaults.standard.set(logou?.access_token, forKey: Constants.tokenValue )
            UserDefaults.standard.synchronize()
            TasksDB().syncronize()//sincroniza bd
            self.performSegue(withIdentifier: "segueLogin", sender: self)
            
        }, onError: { _ in
            
            //print("Falha ao realizar login para o usuario
            self.showMessage("Login ou Senha invalido(s)")
            
        }, always: {
            //hide loading
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        
    }
    
    func showMessage(_ msg:String) {
        let myalert = UIAlertController(title: "Mensagem", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        myalert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            
            myalert.dismiss(animated: true)
        })
        self.present(myalert, animated: true)
    }
    
    func showProgress()  {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.animationType = .zoom
        hud.contentColor = UIColor.red
        hud.mode = .indeterminate
        hud.label.text  = "Conectando..."
    }

}

