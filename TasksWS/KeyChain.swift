//
//  KeyChainSwift.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 06/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//

import Foundation
import KeychainSwift


class KeyChain {
    
    class func clearAll() {
        let keychain = KeychainSwift()
        keychain.clear()
    }
    
    class func save(key: String, data: Data) {
        let keychain = KeychainSwift()
        keychain.set(data, forKey: key, withAccess: .accessibleWhenUnlocked)
    }
    
    class func load<T>(key: String, type: T.Type) -> T? {
        let keychain = KeychainSwift()
        let data = keychain.getData(key)
        return data?.to(type: type)
    }
}


extension Data {
    
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
}
