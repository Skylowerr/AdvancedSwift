//
//  UITestingView_UITests.swift
//  AdvancedSwift_UITests
//
//  Created by Emirhan Gökçe on 11.09.2026.
//

import XCTest

//MARK: Naming Structure : test_UnitOfWork_StateUnderTest_ExpectedBehaviour
//MARK: Naming Structure : test_[STRUCT(çünkü classlar view değil)]_[UI Component]_[expected result]
//MARK: Structure : Given, When, Then

// Başında test olmazsa yanında buton olmaz. Test olduğu anlaşılmaz

final class UITestingView_UITests: XCTestCase {
    let app = XCUIApplication() //Oluşturmayı en başa taşıyorum

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_UITestingView_signUpButton_shouldNotSignIn(){

        signUpAndSignIn(shouldTypeOnKeyboard: false)
        
        let navbar = app/*@START_MENU_TOKEN@*/.staticTexts["Welcome"]/*[[".navigationBars.staticTexts[\"Welcome\"]",".staticTexts",".staticTexts[\"Welcome\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        //Then
        XCTAssertFalse(navbar.exists) //Sonuç olarak Welcome yazısı görünmeyecek
    }
    
    func test_UITestingView_signUpButton_shouldSignIn(){
        //Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        //When
        
        
        let navbar = app/*@START_MENU_TOKEN@*/.staticTexts["Welcome"]/*[[".navigationBars.staticTexts[\"Welcome\"]",".staticTexts",".staticTexts[\"Welcome\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        //Then
        XCTAssertTrue(navbar.exists)
    }
    
    
    func test_UITestingView_SignedInHomeView_showAlertButton_shouldDisplayAlert(){
        //Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        //When
        //let navbar = app/*@START_MENU_TOKEN@*/.staticTexts["Welcome"]/*[[".navigationBars.staticTexts[\"Welcome\"]",".staticTexts",".staticTexts[\"Welcome\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ Üstte yaptığımız için gerek yok?
        //XCTAssertTrue(navbar.exists)
        
        //When
        tapAlertButton(shouldDismissAlert: false)
        
        //Then
        let alert = app.alerts.firstMatch //Alert'e id atanamıyor. Onun yerine ilk eşleşeni alırız

        XCTAssertTrue(alert.exists)
        
    }
    
    func test_UITestingView_SignedInHomeView_showAlertButton_shouldDisplayAndDismissAlert(){
        
        //Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        //When
        tapAlertButton(shouldDismissAlert: true)
        
        //Then
        let alert = app.alerts.firstMatch
        let alertExists = alert.waitForExistence(timeout: 5)

        XCTAssertFalse(alertExists)
                
    }
    
    
    
    func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestination(){
        
        //Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        //When
        
        tapNavigationLink(shouldDismiss: false)
        
        
        //Then
        let destinationText = app/*@START_MENU_TOKEN@*/.staticTexts["Destination"]/*[[".otherElements.staticTexts[\"Destination\"]",".staticTexts",".staticTexts[\"Destination\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        XCTAssertTrue(destinationText.exists)
    }
    
    
    func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack() {
        //Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        //When
        tapNavigationLink(shouldDismiss: true)
        
        //Then
        let navbar = app.staticTexts["Welcome"]
        XCTAssertTrue(navbar.exists)


                        
    }
    
    
    
}


//MARK: FUNCTIONS
extension UITestingView_UITests{
    func signUpAndSignIn(shouldTypeOnKeyboard : Bool){
        let textfield = app.textFields["SignUpTextField"]
        textfield.tap()
        
        if shouldTypeOnKeyboard{
            let keyA = app.keys["A"]
            keyA.tap()
            
            let keya = app.keys["a"]
            keya.tap()
            keya.tap()
        }


        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".otherElements",".buttons[\"Geç\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/ //Bunun adı zaten değişmez
        returnButton.tap()
        
        let signUpButton = app.buttons["SignUpButton"] //Bunun adı değişebilir. "SignUpButton" identify ada
        signUpButton.tap()
        
    }
    
    func tapAlertButton(shouldDismissAlert : Bool){
        let showAlertButton = app.buttons["ShowAlertButton"] //Identifier
        showAlertButton.tap()
        
        if shouldDismissAlert{
            let alert = app.alerts.firstMatch
            //XCTAssertTrue(alert.exists) //ZATEN ÜSTTE KONTROL ETTİK. TEKRAR GEREK YOK
            
            let alertOKButton = alert.buttons["OK"] //Buna basınca alert kaybolması lazım
            let alertOKButtonExists = alertOKButton.waitForExistence(timeout: 5)
            XCTAssertTrue(alertOKButtonExists)
            
            alertOKButton.tap()
        }

    }
    
    func tapNavigationLink(shouldDismiss : Bool){
        let navLinkButton = app/*@START_MENU_TOKEN@*/.buttons["NavigationLinkToDestination"]/*[[".otherElements",".buttons[\"Navigate\"]",".buttons[\"NavigationLinkToDestination\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        navLinkButton.tap()

        if shouldDismiss{
            let backButton = app.buttons["BackButton"].firstMatch
            backButton.tap()

        }
    }



}
