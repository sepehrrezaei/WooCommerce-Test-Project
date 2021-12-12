//
//  DatabaseHelper.swift
//  WoocoTestProject
//
//  Created by Sepehr Rezaei on 12/12/21.
//

import Foundation
import RealmSwift

typealias ProductsClosure = (Results<ProductScheme>) -> Void
typealias FinishedClosure = () -> Void

class DatabaseHelper {
    static let instance = DatabaseHelper()
    var realm : Realm!
    
    init() {
        realm = try! Realm()
    }
    
    
    
    // MARK: - product scheme
    
    func saveProductsDatabase(_ schemes : [ProductScheme]) {
        try? realm.write {
            realm.add(schemes,update: .all)
            do {
                try realm.commitWrite()
            } catch {
                // This seems to fail sometimes
                print("⚠️ db fail to commit")
            }
        }
    }
    
    
    func getProductsDatabase (finished: @escaping ProductsClosure) {
        let products = realm.objects(ProductScheme.self)
        finished(products)
    }
    
    func dropProductSchemeTable (finished: @escaping FinishedClosure) {
        try? realm.write {
            let products = self.realm.objects(ProductScheme.self)
            realm.delete(products)
            do {
                try realm.commitWrite()
            } catch {
                print("⚠️ db fail to commit")
            }
            finished()
        }
    }
    
    
    
    // MARK: - end
}
