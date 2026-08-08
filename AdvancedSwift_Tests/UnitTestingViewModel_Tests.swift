//
//  UnitTestingViewModel_Tests.swift
//  AdvancedSwift_Tests
//
//  Created by Emirhan Gökçe on 7.08.2026.
//

import XCTest
@testable import AdvancedSwift //Farklı bir targetta olduğumuz için @testable import diyerek ana dosyayı import ediyoruz
import Combine

//MARK: Naming Structure : test_UnitOfWork_StateUnderTest_ExpectedBehaviour
//MARK: Naming Structure : test_[struct or class]_[function or variable]_[expected result]

// Başında test olmazsa yanında buton olmaz. Test olduğu anlaşılmaz

//MARK: Structure : Given, When, Then

final class UnitTestingViewModel_Tests: XCTestCase {
    var viewModel : UnitTestingViewModel? //var diyoruz çünkü değişecek
    var cancellables = Set<AnyCancellable>()

    //MARK: Testler başlamadan önce set edilir
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UnitTestingViewModel(isPremium: Bool.random())
    }

    //MARK: Testlerden sonra. RESETLEMEK için vs.
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func test_UnitTestingViewModel_isPremium_shouldBeTrue(){
        //Given
        let userIsPremium : Bool = true
        //When
        let vm = UnitTestingViewModel(isPremium: userIsPremium)
        //Then
        XCTAssertTrue(vm.isPremium)
    }
    
    func test_UnitTestingViewModel_isPremium_shouldBeFalse(){
        //Given
        let userIsPremium : Bool = false
        //When
        let vm = UnitTestingViewModel(isPremium: userIsPremium)
        //Then
        XCTAssertFalse(vm.isPremium)
    }
    
    //MARK: Bu biraz daha güvenli. Çünkü random atama yapıyorsun
    func test_UnitTestingViewModel_isPremium_shouldBeInjectedValue(){
        //Given
        let userIsPremium : Bool = Bool.random()
        //When
        let vm = UnitTestingViewModel(isPremium: userIsPremium)
        //Then
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }
    
    //MARK: Daha da güvenli. Çünkü 10 kere deniyoruz true false değerlerini.
    func test_UnitTestingViewModel_isPremium_shouldBeInjectedValue_stress(){
        for _ in 0..<10{
            //Given
            let userIsPremium : Bool = Bool.random()
            //When
            let vm = UnitTestingViewModel(isPremium: userIsPremium)
            //Then
            XCTAssertEqual(vm.isPremium, userIsPremium)
        }
    }
    
    func test_UnitTestingViewModel_dataArray_shouldBeEmpty(){
        //Given -> Burada gerek yok
        
        //When
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingViewModel_dataArray_shouldAddItem(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        let loopCount : Int = Int.random(in: 1..<100) //Dümdüz sayı girmek yerine daha da karmaşıklaştırıyoruz
        for _ in 0..<loopCount{
            vm.addItem(item: UUID().uuidString)
        }
        
        //Then
        XCTAssertTrue(!vm.dataArray.isEmpty)
        XCTAssertFalse(vm.dataArray.isEmpty)
        
        XCTAssertEqual(vm.dataArray.count, loopCount)
        XCTAssertNotEqual(vm.dataArray.count, 0)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    //MARK: Edge caseler olabilir. Bunun için ayrı test oluştur
    func test_UnitTestingViewModel_dataArray_shouldNotAddBlankString(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        vm.addItem(item: "")
        
        //Then
        XCTAssertTrue(vm.dataArray.isEmpty) //Boş olduğunu, orada veri olmadığını doğruluyor
    }
    
    func test_UnitTestingViewModel_dataArray_shouldNotAddBlankString2(){
        //Given
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        //When
        vm.addItem(item: "")
        //Then
        XCTAssertTrue(vm.dataArray.isEmpty) //Boş olduğunu, orada veri olmadığını doğruluyor
    }
    
    func test_UnitTestingViewModel_selectedItem_shouldStartAsNil(){
        //Given

        //When
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        
        //select valid item
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)

        //select invalid item(EDGE CASE) -> nil'e geri döndürmediğimiz için hata verdi. Kodu düzenlemememiz lazım
        vm.selectItem(item: UUID().uuidString) //dataArray'in içi boşken bir şey arıyoruz. Nil dönmesi lazım
        //Then
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingViewModel_selectedItem_shouldBeSelected(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        //Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, newItem)
    }
    
    func test_UnitTestingViewModel_selectedItem_shouldBeSelected_stress(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        let loopCount : Int = Int.random(in: 1..<100)
        var itemsArray : [String] = [] //
        
        for _ in 0..<loopCount{
            let newItem = UUID().uuidString
            vm.addItem(item: newItem) //hem vm'in içine atıyoruz elemanı
            itemsArray.append(newItem) // Hem de lokalde oluşturduğumuz yere atıyoruz
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
        vm.selectItem(item: randomItem)
         
        //Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, randomItem)
    }
    
    func test_UnitTestingViewModel_saveItem_shouldThrowError_itemNotFound(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        let loopCount : Int = Int.random(in: 1..<100)
        
        for _ in 0..<loopCount{
            vm.addItem(item: UUID().uuidString)
        }

        //Then
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString)) // Item ekliyor fakat eklediği item dataArray'in içerisinde olmadığı için itemNotFound fırlatır
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should Throw Item Not Found Error!") { error in
            let returnedError = error as? UnitTestingViewModel.DataError
            XCTAssertEqual(returnedError, .itemNotFound)
        }
        
    }
    
    func test_UnitTestingViewModel_saveItem_shouldThrowError_noData(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        let loopCount : Int = Int.random(in: 1..<100)
        
        for _ in 0..<loopCount{
            vm.addItem(item: "")
        }

        //Then
        XCTAssertThrowsError(try vm.saveItem(item: "")) // Item ekliyor fakat eklediği item dataArray'in içerisinde olmadığı için itemNotFound fırlatır
        XCTAssertThrowsError(try vm.saveItem(item: ""), "Should Throw No Data Error!") { error in
            let returnedError = error as? UnitTestingViewModel.DataError
            XCTAssertEqual(returnedError, .noData)
        }
        
    }
    
    func test_UnitTestingViewModel_saveItem_shouldThrowError_noData2(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        let loopCount : Int = Int.random(in: 1..<100)
        
        for _ in 0..<loopCount{
            vm.addItem(item: "")
        }
        
        //Then
        do {
            try vm.saveItem(item: "")
        } catch let error {
            let returnedError = error as? UnitTestingViewModel.DataError
            XCTAssertEqual(returnedError, .noData)
        }
               
    }
    
    func test_UnitTestingViewModel_saveItem_shouldSaveItem(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        let loopCount : Int = Int.random(in: 1..<100)
        var itemsArray : [String] = [] //
        
        for _ in 0..<loopCount{
            let newItem = UUID().uuidString
            vm.addItem(item: newItem) //hem vm'in içine atıyoruz elemanı
            itemsArray.append(newItem) // Hem de lokalde oluşturduğumuz yere atıyoruz
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
         
        //Then
        XCTAssertNoThrow(try vm.saveItem(item: randomItem))
        XCTAssertFalse(randomItem.isEmpty) // 0 gelip "" olursa false olsun diyoruz
        
        //Alternatif
        do {
            try vm.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
        
    }
    
    //MARK: DEPENDENCY INJECTION
    
    func test_UnitTestingViewModel_downloadWithEscaping_shouldReturnItems(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        let expectation = XCTestExpectation(description: "Should return items after 3 seconds.")
        vm.$dataArray
            .dropFirst()
            .sink{ returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        vm.downloadWithEscaping()
    
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        
    }
    
    func test_UnitTestingViewModel_downloadWithCombine_shouldReturnItems(){
        //Given
        let vm = UnitTestingViewModel(isPremium: Bool.random())

        //When
        let expectation = XCTestExpectation(description: "Should return items after a second.")
        vm.$dataArray
            .dropFirst()
            .sink{ returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        vm.downloadWithCombine()
    
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        
    }
    
    
    
    

}

