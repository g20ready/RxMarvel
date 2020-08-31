//
//  Alamofire+Rx.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 29/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import RxSwift
import Alamofire

extension Alamofire.Session : ReactiveCompatible { }

extension Reactive where Base: Alamofire.Session {
    
    func request<T: Decodable>(route: URLRequestConvertible) -> Observable<T> {
        if let url = try? route.asURLRequest().url {
            print("Request for route: \(url.absoluteString)")
        }
        
        return Observable.create { observer -> Disposable in
            let request = self.base.request(route)
            // Continue wit request
            request.response { (response: AFDataResponse<Data?>) in
                if let error = response.error {
                    observer.on(.error(error))
                }
                if let data = response.data {
                    do {
                        let deserializedData = try JSONDecoder().decode(T.self, from: data)
                        observer.on(.next(deserializedData))
                    } catch {
                        observer.on(.error(error))
                    }
                }
                observer.on(.completed)
            }
            request.resume()
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}



