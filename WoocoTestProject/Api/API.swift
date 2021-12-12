//
//  API.swift
//  WoocoTestProject
//
//  Created by Sepehr Rezaei on 12/12/21.
//
import Moya

enum API {
    case products
}

extension API: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Urls.mainUrl) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .products:
            return Urls.products
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .products:
            return .requestParameters(parameters: ["consumer_key": UserDefaults.init().string(forKey: Strings.CONSUMER_KEY) ?? "", "consumer_secret" : UserDefaults.init().string(forKey: Strings.CONSUMER_SECRET) ?? ""], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
