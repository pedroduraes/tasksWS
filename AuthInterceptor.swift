//
//  AuthInterceptor.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 07/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//

import Foundation
import EasyRest
import Alamofire
import Genome


class AuthInterceptor: Interceptor {
    
    required init() { }
    
    func requestInterceptor<T>(_ api: API<T>) where T : NodeInitializable {
        let token = "Bearer \(User.token)"
        print ("token do interceptor = \(token)")
        api.headers["Authorization"] = token
    }
    
    func responseInterceptor<T>(_ api: API<T>, response: DataResponse<Any>) where T : NodeInitializable {
        
    }
    
    
}

