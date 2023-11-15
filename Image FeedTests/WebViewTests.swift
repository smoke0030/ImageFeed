//
//  Image_FeedTests.swift
//  Image FeedTests
//
//  Created by Сергей on 14.11.2023.
//

import XCTest
import Foundation
@testable import Image_Feed

final class Image_FeedTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        
        let viewControlelr = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter  = WebViewPresenter(authHelper: authHelper)
        viewControlelr.presenter = presenter
        presenter.view = viewControlelr
        
        //when
        
        presenter.viewDidLoad()
        
        //then
        
        XCTAssertTrue(viewControlelr.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        
        let shouldHidePRogress = presenter.shouldHideProgress(for: progress)
        
        //then
        
        XCTAssertFalse(shouldHidePRogress)
        
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //when
        
        let shouldHidePRogress = presenter.shouldHideProgress(for: progress)
        
        //then
        
        XCTAssertTrue(shouldHidePRogress)
        
    }
    
    func testAuthHelperAuthURL() {
        //given
        
        let configuration = AuthConfiguration.standart
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        //then
        
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        
    }
    
    func testCodeFromURL() {
        //given
        let authHelper = AuthHelper()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [URLQueryItem(name: "code", value: "test code")]
        guard let url = urlComponents?.url else { return }
        
        //when
        
        let code = authHelper.code(form: url)
        
        //then
        
        XCTAssertEqual(code, "test code")
    }
    
    
}


final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: Image_Feed.WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    
    
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: Image_Feed.WebViewPresenterProtocol?
    var loadRequestCalled = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
