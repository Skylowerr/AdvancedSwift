//
//  NewMockDataService.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 8.08.2026.
//

import Foundation
import SwiftUI
import Combine

protocol NewDataServiceProtocol{
    func downloadWithEscaping(completion : @escaping(_ items : [String])-> ())
    func downloadWithCombine() -> AnyPublisher <[String], Error>
}

class NewMockDataService: NewDataServiceProtocol{
    let items : [String]
    
    init(items: [String]?) {
        self.items = items ?? ["ONE", "TWO", "THREE"]
    }
    
    func downloadWithEscaping(completion : @escaping(_ items : [String])-> ()){
        DispatchQueue.main.asyncAfter(deadline: .now()+3){
            completion(self.items)
        }
    }
    
    func downloadWithCombine() -> AnyPublisher <[String], Error>{
        Just(items)
            .tryMap({publishedItems in
                guard !publishedItems.isEmpty else{
                    throw URLError(.badServerResponse)
                }
                return publishedItems
            })
            .eraseToAnyPublisher()
    }
}
