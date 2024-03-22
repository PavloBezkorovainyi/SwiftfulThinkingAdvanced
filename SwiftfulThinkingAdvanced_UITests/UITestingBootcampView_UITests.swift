//
//  UITestingBootcampView_UITests.swift
//  SwiftfulThinkingAdvanced_UITests
//
//  Created by Павел Бескоровайный on 21.03.2024.
//

import XCTest

//Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
//Naming Structure: test_[struct or class]_[variable or fucntion]_[expected results]
//Testing Structure: Given, When, Then

final class UITestingBootcampView_UITests: XCTestCase {
  
  let app = XCUIApplication()
  
  override func setUpWithError() throws {
    continueAfterFailure = false
//    app.launchArguments = ["-UITest_startSignedIn"]
//    app.launchEnvironment = ["-UITest_startSignedIn2" : "true"]
    app.launch()
  }
  
  override func tearDownWithError() throws {
  }
  
  func test_UITestingBootcampView_signUpButton_shouldNotSignIn() {
    //Given
    signUpAndSignIn(shouldTypeOnKeyboard: false)
    
    //When
    let navBar =  app.navigationBars["Welcome"]
    
    //Then
    XCTAssertFalse(navBar.exists)
  }
  
  func test_UITestingBootcampView_signUpButton_shouldSignIn() {
    //Given
    signUpAndSignIn(shouldTypeOnKeyboard: true)
    
    //When
    let navBar =  app.navigationBars["Welcome"]
    
    //Then
    XCTAssertTrue(navBar.exists)
  }
  
  func test_SignedInHomeView_showAlertButton_shouldDisplayAlert() {
    //Given
    signUpAndSignIn(shouldTypeOnKeyboard: true)
    
    //When
    tapAlertButton(shouldDismissAlert: false)

    //Then
    let alert = app.alerts.firstMatch
    XCTAssertTrue(alert.exists)
  }
  
  func test_SignedInHomeView_showAlertButton_shouldDisplayAndDismissAlert() {
    //Given
    signUpAndSignIn(shouldTypeOnKeyboard: true)
    
    //When
    tapAlertButton(shouldDismissAlert: true)
    
    //Then
    let alertExists = app.alerts.firstMatch.waitForExistence(timeout: 5)
    XCTAssertFalse(alertExists)
  }
  
  func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestination() {
    //Given
    signUpAndSignIn(shouldTypeOnKeyboard: true)
    
    //When
    tapnavigationLink(shouldDismissDestanation: false)
    
    //Then
    let destinationText = app.staticTexts["Destination"]
    XCTAssertTrue(destinationText.exists)
  }
  
  func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack() {
    //Given
    signUpAndSignIn(shouldTypeOnKeyboard: true)
    //When
    tapnavigationLink(shouldDismissDestanation: true)
    
    //Then
    let navBar = app.navigationBars["Welcome"]
    let navBarExists = navBar.waitForExistence(timeout: 5)
    XCTAssertTrue(navBarExists)
  }
  
//  func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack2() {
//    //When
//    tapnavigationLink(shouldDismissDestanation: true)
//    
//    //Then
//    let navBar = app.navigationBars["Welcome"]
//    let navBarExists = navBar.waitForExistence(timeout: 5)
//    XCTAssertTrue(navBarExists)
//  }

}

//MARK: Functions

extension UITestingBootcampView_UITests {
  func signUpAndSignIn(shouldTypeOnKeyboard: Bool) {
    let addYourNameTextField = app.textFields["SignUpTextField"]
    
    addYourNameTextField.tap()
    
    if shouldTypeOnKeyboard {
      let AKey = app.keys["A"]
      AKey.tap()
      let aKey = app.keys["a"]
      aKey.tap()
      aKey.tap()
    }
    
    let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
    returnButton.tap()
    
    let signUpButton = app.buttons["SignUpButton"]
    signUpButton.tap()
  }
  
  func tapAlertButton(shouldDismissAlert: Bool) {
    let showAlertButton = app.buttons["ShowAlertButton"]
    showAlertButton.tap()
    
    if shouldDismissAlert {
      let alert = app.alerts.firstMatch
      
      let alertOkButton = alert.buttons["OK"]

      let alertOkButtonExists = alertOkButton.waitForExistence(timeout: 5)
      XCTAssertTrue(alertOkButtonExists)
      
      alertOkButton.tap()
    }
  }
  
  func tapnavigationLink(shouldDismissDestanation: Bool) {
    let navLinkButton = app/*@START_MENU_TOKEN@*/.buttons["NavigationLinkToDestination"]/*[[".buttons[\"Navigate\"]",".buttons[\"NavigationLinkToDestination\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    navLinkButton.tap()
    
    if shouldDismissDestanation {
      let backButton = app.navigationBars.buttons["Welcome"]
      backButton.tap()
    }
  }
}
