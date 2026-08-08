//
//  NewMockDataService_Tests.swift
//  AdvancedSwift_Tests
//
//  Created by Emirhan Gökçe on 8.08.2026.
//

import XCTest
@testable import AdvancedSwift
import Combine

final class NewMockDataService_Tests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }
    
    func test_NewMockDataService_init_doesSetValuesCorrectly(){
        //Given
        let items : [String]? = nil
        let items2 : [String]? = []
        let items3 : [String]? = [UUID().uuidString, UUID().uuidString]

        
        //When
        let dataService = NewMockDataService(items: items) //Nil olmasına rağmen one two three olarak 3 el. olacak
        let dataService2 = NewMockDataService(items: items2) //Boş olacak
        let dataService3 = NewMockDataService(items: items3) // 2 elemanlı rastgele değer olacak
        
        
        //Then
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertEqual(dataService3.items.count, items3?.count)
    }
    
    func test_NewMockDataService_downloadItemsWithEscaping_doesReturnValues(){
        //Given
        let dataService = NewMockDataService(items: nil)

        //When
        var items : [String] = []
        let expectations = XCTestExpectation()
        
        dataService.downloadWithEscaping { returnedItems in
            items = returnedItems
            expectations.fulfill()
        }
        
        //Then
        wait(for: [expectations], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_downloadItemsWithCombine_doesReturnValues(){
        //Given
        let dataService = NewMockDataService(items: nil)

        //When
        var items : [String] = []
        let expectations = XCTestExpectation()
        
        dataService.downloadWithCombine()
            .sink { completion in
                switch completion{
                case .finished :
                    expectations.fulfill()
                case .failure(let error):
                    XCTFail()
                }
            } receiveValue: { returnedItems in
                items = returnedItems
            }.store(in: &cancellables)

        //Then
        wait(for: [expectations], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_downloadItemsWithCombine_doesFail(){
        //Given
        let dataService = NewMockDataService(items: [])

        //When
        var items : [String] = []
        let expectation = XCTestExpectation(description: "Does throw an error")
        let expectation2 = XCTestExpectation(description: "Does throw URLError.badServerResponse")

        
        dataService.downloadWithCombine()
            .sink { completion in
                switch completion{
                case .finished :
                    XCTFail()
                case .failure(let error):
                    expectation.fulfill()
                    let urlError = error? as URLError
                    XCTAssertEqual(urlError, URLError(.badServerResponse))
                    
                    if urlError == URLError(.badServerResponse){
                        expectation2.fulfill()
                    }
                }
            } receiveValue: { returnedItems in
                items = returnedItems
            }.store(in: &cancellables)

        //Then
        wait(for: [expectation,expectation2], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }

    

}
