//
//  NetworkRequestAPI.swift
//  MVVM+RxSwift
//
//  Created by shenzhiqiang on 2019/1/1.
//  Copyright © 2019年 申智强. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

//MARK: - API
private let NetworkRequestAPIProvider = MoyaProvider<NetworkRequestAPI>()

public enum NetworkRequestAPI{
    case channels  //获取频道列表
    case playlist(String) //获取歌曲
}

extension NetworkRequestAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .channels:
            return URL(string: "https://www.douban.com")!
        case .playlist(_):
            return URL(string: "https://douban.fm")!
        }
    }
    
    public var path: String {
        switch self {
        case .channels:
            return "/j/app/radio/channels"
        case .playlist(_):
            return "/j/mine/playlist"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .playlist(let channel):
            var params: [String: Any] = [:]
            params["channel"] = channel
            params["type"] = "n"
            params["from"] = "mainsite"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}

//MARK: - Manager
class NetworkRequestManager {
    static let shared = NetworkRequestManager()
    private let disposeBag = DisposeBag()
    private init() {}
    
    func request(_ api: NetworkRequestAPI) {
        NetworkRequestAPIProvider.rx.request(api).subscribe(onSuccess: { (response) in
            
        }, onError: { (error) in
            
        }).disposed(by: disposeBag)
    }
}
