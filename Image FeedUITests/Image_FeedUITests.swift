//
//  Image_FeedUITests1.swift
//  Image FeedUITests1
//
//  Created by Сергей on 20.11.2023.
//

import XCTest

final class Image_FeedUITests1: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        
        continueAfterFailure = false
        
        app.launch()

      
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        
        sleep(3)
        
        loginTextField.typeText("ft.priest@gmail.com")
        
        app.buttons["Done"].tap()
        
        sleep(3)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("Vtyfvdskmgfhjkm12")
        
        app.buttons["Done"].tap()
        
        sleep(3)
        
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
        
    func testFeed() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).waitForExistence(timeout: 4))

                let tableQuery = app.tables
                let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
                XCTAssertTrue(cell.waitForExistence(timeout: 3))
        
                cell.swipeDown()
        
                sleep(2)

                let cellToLike = tableQuery.children(matching: .cell).element(boundBy: 1)
        
                cellToLike.buttons["like_button"].tap()
        
                sleep(3)

                cellToLike.tap()
                sleep(3)

                let image = app.scrollViews.images.element(boundBy: 0)
                image.pinch(withScale: 3, velocity: 1)
                image.pinch(withScale: 0.5, velocity: -1)

                XCTAssertTrue(app.buttons["back_button"].waitForExistence(timeout: 3))
                app.buttons["back_button"].tap()
    }
        
        func testProfile() throws {
            sleep(5)
            
            app.tabBars.buttons.element(boundBy: 1).tap()
            
            XCTAssertTrue(app.staticTexts["Сергей Видишев"].exists)
            XCTAssertTrue(app.staticTexts["smoke0030"].exists)
            
            app.buttons["exitButton"].tap()
            
            sleep(2)
            
            app.alerts["До встречи!"].scrollViews.otherElements.buttons["Да"].tap()
        }
    
    
    

   
}
