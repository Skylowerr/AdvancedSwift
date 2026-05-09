//
//  DependencyInjection.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 9.05.2026.
//

import SwiftUI
import Combine

//MARK: PROBLEMS WITH SINGLETONS
//1. Singletons are GLOBAL -> New Version : let dataService : ProductionDataService
//2. Can't customize the init! -> New Version : init(url : URL){self.url = url}
//3. Can't swap out dependencies -> New version :


struct PostsModel : Identifiable, Codable{
    /*
     {
     "userId": 1,
     "id": 2,
     "title": "qui est esse",
     "body": "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla"
     } AYNI ŞEKILDE YAZ
     */
    
    let userId : Int
    let id : Int
    let title : String
    let body : String
}


protocol DataServiceProtocol{
    func getData() -> AnyPublisher<[PostsModel], Error>
}



final class ProductionDataService : DataServiceProtocol{
//    static let instance = ProductionDataService() // Singleton
    //let url : URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    //Üstteki gibi yazmaktansa, alttaki gibi customize edebilirim. Fakat init(url:) dersem, ProductionDataService olan yerlere url: diyip URLsini yazmam gerek.
    let url : URL //
    init(url : URL){
        self.url = url
    }
    
    
     func getData() -> AnyPublisher<[PostsModel], Error>{
        URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [PostsModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

final class MockDataService : DataServiceProtocol{
    
    let testData : [PostsModel]
    init(data : [PostsModel]?){ //Fake data ile de initialize edebiliriz, o olmadan da.
        self.testData = data ?? [
            PostsModel(userId: 1, id: 1, title: "One", body: "one"),
            PostsModel(userId: 2, id: 2, title: "Two", body: "two"),

        ]
    }
    
    func getData() -> AnyPublisher<[PostsModel], any Error> {
        Just(testData)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }
    
    
}



@Observable
final class DependencyInjectionViewModel{
    var dataArray : [PostsModel] = []
    var cancellables = Set<AnyCancellable>()
    let dataService : DataServiceProtocol
    
    init(dataService : DataServiceProtocol){
        self.dataService = dataService
        loadPosts()
    }
    private func loadPosts(){
        dataService.getData()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedPosts in
                self?.dataArray = returnedPosts
            }
            .store(in: &cancellables)

    }
}

struct DependencyInjection: View {
    @State private var vm : DependencyInjectionViewModel
    
    init(dataService : DataServiceProtocol){
        _vm = State(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(vm.dataArray){post in
                    Text(post.title)
                }
            }
        }
    }
}

#Preview {
    
//    let dataService = ProductionDataService(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
     let dataService = MockDataService(data:
     [PostsModel(userId: 1234, id: 1232, title: "test", body: "test")])
    DependencyInjection(dataService: dataService)
}
