//
//  RealmDatastore.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/24.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import Mapper
import RealmSwift

enum DatastoreError: Error {
    case unexpectedObject
    case unknown
}

protocol RealmDatastore {
    associatedtype TargetObject
    func map(json: NSDictionary, to object: TargetObject, resetRelations: Bool) throws -> TargetObject
    func createOrUpdate(json: Any?, resetRelations: Bool, inTransaction: Bool) -> TargetObject?
    func bulkCreateOrUpdate(json: Any?, resetRelations: Bool, inTransaction: Bool) -> Array<TargetObject>?
}

extension RealmDatastore where TargetObject: Object {
    
    // MARK - CRUD -
    
    func createOrUpdate(json: Any?,
                        resetRelations: Bool = false,
                        inTransaction: Bool = false) -> TargetObject? {
        guard let json = json as? NSDictionary else {
            return nil
        }
        
        return deserialize(
            json: json,
            resetRelations: resetRelations,
            inTransaction: inTransaction)
    }
    
    func bulkCreateOrUpdate(json: Any?,
                                   resetRelations: Bool = false,
                                   inTransaction: Bool = false) -> Array<TargetObject>? {
        guard let objectsJson = json as? Array<NSDictionary> else {
            return nil
        }
        
        if inTransaction {
            return objectsJson.flatMap({ (objectJson) -> TargetObject? in
                return deserialize(
                    json: objectJson,
                    resetRelations: resetRelations,
                    inTransaction: true)
            })
        }
        else {
            var objects = [TargetObject]()
            try! Realm().write { (_) in
                objects = objectsJson.flatMap({ (objectJson) -> TargetObject? in
                    return deserialize(
                        json: objectJson,
                        resetRelations: resetRelations,
                        inTransaction: true)
                })
            }
            
            return objects
        }
    }
    
    func findOrCreate(from json: NSDictionary) -> TargetObject? {
        let realm = try! Realm()
        guard
            let primaryKey = TargetObject.primaryKey(),
            let primaryJsonKey = TargetObject.primaryJsonKey
            else {
                return TargetObject()
        }
        
        guard let key = json[primaryJsonKey],
            !(key is NSNull) else {
                return nil
        }
        
        if let object = realm.object(ofType: TargetObject.self, forPrimaryKey: key) {
            return object
        }
        else {
            let object = TargetObject()
            object.setValue(key, forKey: primaryKey)
            return object
        }
    }
    
    
    // MARK: - Deserialize -
    
    private func deserialize(json: NSDictionary,
                             resetRelations: Bool,
                             inTransaction: Bool) -> TargetObject? {
        
        let realm = try! Realm()
        guard var object = findOrCreate(from: json) else {
            return nil
        }
        
        do {
            if inTransaction {
                object = try map(json: json, to: object, resetRelations: resetRelations)
                realm.add(object, update: TargetObject.primaryKey() != nil)
            }
            else {
                try realm.write {
                    try DispatchQueue.global(qos: .userInitiated).sync {
                        object = try map(json: json, to: object, resetRelations: resetRelations)
                    }
                    realm.add(object, update: TargetObject.primaryKey() != nil)
                }
            }
        }
        catch {
            return nil
        }
        
        return object
    }
}


import RealmSwift

extension Object {
    
    class var primaryJsonKey: String? {
        return self.primaryKey()
    }
}
