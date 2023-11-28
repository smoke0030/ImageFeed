//
//  Image_FeedUITests1.swift
//  Image FeedUITests1
//
//  Created by Сергей on 20.11.2023.
//

import XCTest

final class Image_FeedUITests1: XCTestCase {
    
    let yourEmail = ""
    let yourPassword = ""
    let yourNameLabel = ""
    let yourLoginLabel = ""
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 3))
        loginTextField.tap()
        
        sleep(2)
        
        loginTextField.typeText(yourEmail)
        
        app.buttons["Done"].tap()
        
        sleep(3)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
        
        passwordTextField.tap()
        
        passwordTextField.typeText(yourPassword)
        
        sleep(1)
        
        app.buttons["Done"].tap()
        
        sleep(3)
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        sleep(5)
        
        let tableQuery = app.tables
        let cell = tableQuery.descendants(matching: .cell).element(boundBy: 0)
        cell.swipeDown()
        
        sleep(2)
        let cellLike = tableQuery.descendants(matching: .cell).element(boundBy: 1)
        
        let likebutton = cellLike.descendants(matching: .button).element(boundBy: 0)
        
        likebutton.tap()
        
        sleep(2)
        
        likebutton.tap()
        
        sleep(2)
        
        cellLike.tap()
        
        sleep(3)
            
        let image = app.scrollViews.images.element(boundBy: 0)
           
        XCTAssertTrue(image.waitForExistence(timeout: 3))
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
            
        let navBackButtonWhiteButton = app.buttons["back_button"]
        navBackButtonWhiteButton.tap()

    }
    
    func testProfile() throws {
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[yourNameLabel].exists)
        XCTAssertTrue(app.staticTexts[yourLoginLabel].exists)
        
        app.buttons["exitButton"].tap()
        
        sleep(2)
        
        app.alerts["До встречи!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
