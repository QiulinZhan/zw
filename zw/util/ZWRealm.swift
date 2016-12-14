//
//  ZWRealm.swift
//  zw
//
//  Created by 战秋林 on 2016/12/14.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import RealmSwift

class ZWRealm {
    static let shared = ZWRealm()
    private init() {
        var config = Realm.Configuration()
        config.fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.zw")?.appendingPathComponent("default.realm")
        Realm.Configuration.defaultConfiguration = config
    }
    func query(action: @escaping (_ realm: Realm) -> Void) {
        let realm = try! Realm()
        action(realm)
    }
    
    func write(_ object: Object, _ action: @escaping (_ realm: Realm) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: true)
        }
        action(realm)
    }
    
    func write(_ object: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    func write<S: Sequence>(_ objects: S, _ action: @escaping (_ realm: Realm) -> Void) where S.Iterator.Element: Object {
        let realm = try! Realm()
        try! realm.write {
            realm.add(objects, update: true)
        }
        action(realm)
    }
    
    func delete<T: Object>(_ object: T.Type, forPrimaryKey: Any, _ action: @escaping (_ realm: Realm) -> Void) {
        let realm = try! Realm()
        if let obj = realm.object(ofType: object, forPrimaryKey: forPrimaryKey) {
            try! realm.write {
                realm.delete(obj)
            }
            action(realm)
        }
    }
    
    func update(_ action: @escaping (_ realm: Realm) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            action(realm)
        }
    }
}
