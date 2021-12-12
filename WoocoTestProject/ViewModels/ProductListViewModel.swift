//
//  ProductViewModel.swift
//  WoocoTestProject
//
//  Created by Sepehr Rezaei on 12/12/21.
//
import Foundation
import RealmSwift

protocol ViewModelProtocol: AnyObject {
    func retrivedDataFromServer()
    func retrivedDataFromLocalDatabase()
}

class ProductListViewModel {
    weak var delegate: ViewModelProtocol?
    private let networkManager: NetworkManager
    var productsList : Results<ProductScheme>!
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        self.fetchDataFromLocalDatabase()
        self.fetchDataFormServer()
    }
    
    func fetchDataFormServer () {
        networkManager.fetchProductsList(completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let productsResponse):
                self?.createDatabaseModels(productsResponse)
                strongSelf.delegate?.retrivedDataFromServer()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func createDatabaseModels (_ array : [ProductResult]) {
        // 1-> drop database (because there is a possibility that an item has been removed from servers list ) 2-> save new array to database
        DatabaseHelper.instance.dropProductSchemeTable {
            var dbModels : [ProductScheme] = []
            for temp in array {
                dbModels.append(ProductScheme(id: temp.id, name: temp.name, permalink: temp.permalink, image: temp.image))
            }
            DatabaseHelper.instance.saveProductsDatabase(dbModels)
        }
        
    }
    
    func fetchDataFromLocalDatabase () {
        DatabaseHelper.instance.getProductsDatabase { products in
            self.productsList = products
            self.delegate?.retrivedDataFromLocalDatabase()
        }
    }
    
}
