//
//  PostService.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 06/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//

import Foundation

import Foundation
import EasyRest


class PostService: Service<PostRoute> {
    
    override var interceptors: [Interceptor]? {
        get{
            return [AuthInterceptor()]
        }
    }
    
    override var base: String { return AppConfig.kHttpEndpoint }
    
//    func getTasks(onSuccess: @escaping (Response<[Tasks]>?) -> Void,
//                  onError: @escaping (RestError?) -> Void,
//                  always: @escaping () -> Void) {
//        try! call(.getPosts, type: [Tasks].self, onSuccess: onSuccess,
//                  onError: onError, always: always)
//    }
    
    func getTasks(onSuccess: @escaping (Response<Tasks>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.listTasks, type: Tasks.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func login(username:String, password:String, onSuccess: @escaping (Response<Login>?) -> Void,
               onError: @escaping (RestError?) -> Void,
               always: @escaping () -> Void) {
        try! call(.login(username, password), type: Login.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func save(item : TaskItem, onSuccess: @escaping (Response<TaskItem>?) -> Void,
               onError: @escaping (RestError?) -> Void,
               always: @escaping () -> Void) {
        try! call( .save(item) , type: TaskItem.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    func delete(item : TaskItem, onSuccess: @escaping (Response<TaskItem>?) -> Void,
              onError: @escaping (RestError?) -> Void,
              always: @escaping () -> Void) {
        try! call( .delete(item) , type: TaskItem.self, onSuccess: onSuccess,
                   onError: onError, always: always)
    }
    
}
