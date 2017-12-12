//
//  TasksDB.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 08/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//

import Foundation
import RealmSwift

extension TasksDB {
    func toTaskItem() -> TaskItem {
        let item = TaskItem()
        item.id = self.id
        item.expirationdate = self.expirationdate
        item.title = self.title
        item.descriptionTask = self.descriptionTask
        item.iscomplete = self.iscomplete.boolValue ? true : false
        item.owner = self.owner
        item.isSyncronized = self.isSyncronized.boolValue ? true : false
        return item
    }
}

class TasksDB: Object {
    @objc dynamic var id : String?
    @objc dynamic var expirationdate : String?
    @objc dynamic var title : String?
    @objc dynamic var descriptionTask : String?
    @objc dynamic var iscomplete : ObjCBool = false
    @objc dynamic var owner : String?
    @objc dynamic var isSyncronized : ObjCBool = false

    func syncronize()  {
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "isSyncronized == %@", false as CVarArg )
        let items = realm.objects(TasksDB.self).filter(predicate)
        print("**********ITEMS A SINCRONIZAR************")
        items.forEach{
            let updateItem : TaskItem = $0.toTaskItem()
            let oldId = updateItem.id!
            if (oldId.range(of: "offline") != nil) { updateItem.id = "" }//para forcar a inclusao no webservice
            //todo : VERIFICAR ESQUEMA PARA UPDATE QUANDO O ITEM AINDA NAO TEM ID DO BD
            PostService().save(item:  updateItem , onSuccess: { response in
                let itemToUpdate : TasksDB = (response?.body?.toTaskDB())!
                itemToUpdate.isSyncronized = true
                itemToUpdate.update(oldId)
                print("Atualizado item \(updateItem.id!) <-> \(String(describing: response?.body?.id!))")
            }, onError: { _ in
                print("Falha sincronizar")
            }, always: {
                //hide loading
            })
            
        }
        print("***************************************")
    }
    
    func save() -> TasksDB  {
        var returnValue : TasksDB
        if self.id != "" {
            returnValue = self.update(self.id!)
        }else {
            returnValue = self.insert()
        }
        printItems()
        return returnValue
    }
    
    func delete()  {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id == %@", self.id!)
        let item = realm.objects(TasksDB.self).filter(predicate).first
        if item != nil {
            // Delete an object with a transaction
            try! realm.write {
                realm.delete(item!)
            }
        }
    }
    
    func listAll() -> Results< TasksDB> {
        let realm = try! Realm()
        return realm.objects(TasksDB.self)
    }
    
    func listAll() -> [TasksDB] {
        var items = [TasksDB]()
        let result :  Results< TasksDB> = self.listAll()
        for item in result {
            items.append(item)
        }
        return items
    }
    
    func listAll() -> [TaskItem] {
        var items = [TaskItem]()
        let result :  Results< TasksDB> = self.listAll()
        for item in result {
            items.append(item.toTaskItem())
        }
        return items
    }
    func listAll() -> Tasks {
        let item : Tasks = Tasks()
        let items : [TaskItem] = self.listAll()
        item.count = items.count
        item.results = items
        
        return item
    }
    
    
    fileprivate func insert() -> TasksDB {
        if "" == self.id { self.id = self.randomId() }
        // Get the default Realm
        let realm = try! Realm()
        // Persist your data easily
        try! realm.write {
            realm.add(self)
        }
        return self
    }
    
    fileprivate func update(_ idUpdate : String) -> TasksDB {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id == %@", idUpdate)
        let item = realm.objects(TasksDB.self).filter(predicate).first
        if item != nil {
            try! realm.write {
                item!.id = self.id
                item?.expirationdate = self.expirationdate
                item?.title = self.title
                item?.descriptionTask = self.descriptionTask
                item?.iscomplete = self.iscomplete
                item?.owner = self.owner
                item?.isSyncronized = self.isSyncronized
            }
            return item!
        }
        else {
            return self.insert() //neste caso, o item ainda nao existe na base, e eh incluido
        }
    }
    
    func deleteAll()  {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    fileprivate func randomId() -> String {
//        let passwordCharacters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".characters)
//        var id = ""
//        for _ in 0..<20 {
//            // generate a random index based on your array of characters count
//            let rand = arc4random_uniform(UInt32(passwordCharacters.count))
//            // append the random character to your string
//            id.append(passwordCharacters[Int(rand)])
//        }
        return "offline\(UUID().uuidString)"
    }
    
    func printItems()  {
        let realm = try! Realm()
        let items = realm.objects(TasksDB.self)
        print("******** IMPRIMINDO DATABASE***********")
        items.forEach{
            print($0)
        }
        print("***************************************")
    }
}
