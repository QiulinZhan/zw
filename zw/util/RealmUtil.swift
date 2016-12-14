//
//  RealmUtil.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/2.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import RealmSwift

class RealmUtil {
    
    static func query(action: @escaping (_ realm: Realm) -> Void) {
        let realm = try! Realm()
        action(realm)
    }
    
    static func write(_ object: Object, _ action: @escaping (_ realm: Realm) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: true)
        }
        action(realm)
    }
    
    static func write(_ object: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    static func write<S: Sequence>(_ objects: S, _ action: @escaping (_ realm: Realm) -> Void) where S.Iterator.Element: Object {
        let realm = try! Realm()
        print(realm.configuration.fileURL!)
        try! realm.write {
            realm.add(objects, update: true)
        }
        action(realm)
    }

    static func delete<T: Object>(_ object: T.Type, forPrimaryKey: Any, _ action: @escaping (_ realm: Realm) -> Void) {
        let realm = try! Realm()
        if let obj = realm.object(ofType: object, forPrimaryKey: forPrimaryKey) {
            try! realm.write {
                realm.delete(obj)
            }
            action(realm)
        }
    }

    static func update(_ action: @escaping (_ realm: Realm) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            action(realm)
        }
    }

}
