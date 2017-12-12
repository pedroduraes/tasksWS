//
//  PostRoute.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 06/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//

import Foundation
import Foundation
import EasyRest


enum PostRoute: Routable {
    
    //case getPosts
    case login(String,String)
    case listTasks
    case save(TaskItem)
    case delete(TaskItem)
    
    var rule: Rule {
        switch self {
        //case .getPosts:
        //    return Rule(method: .get, path: "/posts/",
        //                isAuthenticable: false, parameters: [:])
            
        case let .login(username, password):
            return Rule(method: .post, path: "/oauth/token/", isAuthenticable: false, parameters: [.query:
                [
                    "client_id": AppConfig.client_id,
                    "client_secret": AppConfig.client_secret ,
                    "grant_type": "password",
                    "username": username,
                    "password": password
                ]
                ])
        case .listTasks :
            return Rule(method: .get, path: "/v1/tasks/",
                        isAuthenticable: true, parameters: [:])
        case let .save(item) :
           
            var url = "/v1/tasks/"
            
            if "" != item.id  {
                url = "/v1/tasks/\(item.id!)/"
                return Rule(method: .put, path: url, isAuthenticable: false, parameters: [.body:
                    item
                    ])
                
            }else {
                return Rule(method: .post, path: url, isAuthenticable: false, parameters: [.body:
                    item
                    ])
            }

        case let .delete(item) :
            let url = "/v1/tasks/\(item.id!)/"
            return Rule(method: .delete, path: url, isAuthenticable: false, parameters: [:])
            
            
        }
    }
    
}
