//
//  ServiceData.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 06/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//

import Foundation
import Alamofire

class ServiceData {
 
    var logou : Login?
    
    func Login(_ userName : String, _ password : String ) -> Login? {
        logou = nil
        
        PostService().login(username: userName , password: password , onSuccess: { response in
            self.logou = response?.body
            //self.showMessage("LOGOU COM SUCESSO.")
            //print("Login do usuario '\(String(describing: self.textLogin.text))' realizado com sucesso")
            //self.performSegue(withIdentifier: "navLogin", sender: self.token)
            
            UserDefaults.standard.set(self.logou?.access_token, forKey: Constants.tokenValue )
            UserDefaults.standard.synchronize()
            //return logou
            
        }, onError: { _ in
            
            //print("Falha ao realizar login para o usuario '\(String(describing: self.textLogin.text))'")
            self.logou = nil
            
        }, always: {
            //hide loading
            
        })
        return self.logou
    }
    


    
    
}
