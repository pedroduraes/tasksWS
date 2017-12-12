//
//  Tasks.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 07/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//


import Foundation
import EasyRest
import Genome

class Tasks : BaseModel {
    var count : Int?
    var next : String?
    var previous : String?
    var results : [TaskItem]?
    
    override func sequence(_ map: Map) throws {
        try count <~> map["count"]
        try next <~> map["next"]
        try previous <~> map["previous"]
        try results <~> map["results"]
    }
}
class TaskItem: BaseModel {
    var id : String?
    var expirationdate : String?
    var title : String?
    var descriptionTask : String?
    var iscomplete : Bool?
    var owner : String?
    var isSyncronized : Bool?
    var isPendingDelete : Bool?
    
    override func sequence(_ map: Map) throws {
        try id <~> map["id"]
        try expirationdate <~> map["expiration_date"]
        try title <~> map["title"]
        try descriptionTask <~> map["description"]
        try iscomplete <~> map["is_complete"]
        try owner <~> map["owner"]
    }
    
    func toString() -> String {
        let returnValue = "\(self.title!) \(self.descriptionTask!) \(self.expirationdate!) "
        return returnValue
    }
    
    
}

extension TaskItem {
    func toTaskDB() -> TasksDB {
        let item = TasksDB()
        item.id = self.id
        item.expirationdate = self.expirationdate
        item.title = self.title
        item.descriptionTask = self.descriptionTask
        item.iscomplete = self.iscomplete! ? true : false
        item.owner = self.owner
        if self.isSyncronized != nil {
            item.isSyncronized = self.isSyncronized! ? true : false
        }
        else {
            item.isSyncronized = false
        }
        return item
    }
}
