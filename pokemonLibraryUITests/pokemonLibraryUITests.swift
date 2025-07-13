//
//  pokemonLibraryUITests.swift
//  pokemonLibraryUITests
//
//  Created by 小麦克 on 2025/7/13.
//

import XCTest

final class pokemonLibraryUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAppLaunch() throws {
        // 测试应用程序是否成功启动并显示标题
        XCTAssertTrue(app.navigationBars["宝可梦图鉴"].exists)
        
        // 检查搜索栏是否存在
        XCTAssertTrue(app.textFields["搜索宝可梦名称、属性或能力"].exists)
    }
    
    func testSearchFunction() throws {
        // 获取搜索字段
        let searchField = app.textFields["搜索宝可梦名称、属性或能力"]
        XCTAssertTrue(searchField.exists)
        
        // 点击搜索字段
        searchField.tap()
        
        // 输入搜索关键词
        searchField.typeText("皮卡丘")
        
        // 验证搜索结果
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", "皮卡丘")
        let element = app.staticTexts.element(matching: predicate)
        
        // 等待元素出现，最多等待5秒
        let exists = element.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists, "未找到包含'皮卡丘'的搜索结果")
        
        // 清除搜索
        app.buttons["xmark.circle.fill"].tap()
        
        // 验证所有宝可梦是否重新显示
        let allPokemon = app.scrollViews.firstMatch
        XCTAssertTrue(allPokemon.exists)
    }
    
    func testPokemonDetailNavigation() throws {
        // 找到并点击第一个宝可梦
        if let firstPokemonCell = app.scrollViews.firstMatch.children(matching: .any).firstMatch {
            firstPokemonCell.tap()
            
            // 验证是否进入详情页面
            XCTAssertTrue(app.navigationBars["详情"].exists)
            
            // 检查详情页面元素
            XCTAssertTrue(app.staticTexts["基本信息"].exists)
            XCTAssertTrue(app.staticTexts["描述"].exists)
            XCTAssertTrue(app.staticTexts["能力值"].exists)
            
            // 返回列表页面
            app.navigationBars["详情"].buttons.firstMatch.tap()
            
            // 验证是否返回列表
            XCTAssertTrue(app.navigationBars["宝可梦图鉴"].exists)
        } else {
            XCTFail("未找到可点击的宝可梦项")
        }
    }
}
