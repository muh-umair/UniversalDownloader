//
//  ResponseFactoryTests.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import XCTest

@testable import UniversalDownloader

class ResponseFactoryTests: XCTestCase {
    
}

//MARK: - Tests
extension ResponseFactoryTests {
    
    func testResponseCreationSuccess() {
        
        //arrange
        let mockData = "Univeral Downloader".data(using: .utf8)!
        
        let mockMimeType: String? = nil
        let mockResponseType: Response.Type? = nil
        
        //act
        let response = ResponseFactory.createResponse(withData: mockData, mimeType: mockMimeType, responseType: mockResponseType)
        
        //assert
        XCTAssertNotNil(response.rawData)
        
    }
    
    func testJSONResponseCreationOnTypeSuccess() {
        
        //arrange
        let mockJson = ["Name": "Univeral Downloader"]
        let mockData = try! JSONSerialization.data(withJSONObject: mockJson, options: .prettyPrinted)
        
        let mockMimeType: String? = nil
        let responseType = JSONResponse.self
        
        //act
        let response = ResponseFactory.createResponse(withData: mockData, mimeType: mockMimeType, responseType: responseType)
        
        //assert
        XCTAssertTrue(response is JSONResponse)
        XCTAssertNotNil((response as? JSONResponse)?.json)
        
    }
    
    func testJSONResponseCreationOnMimeTypeSuccess() {
        
        //arrange
        let mockJson = ["Name": "Univeral Downloader"]
        let mockData = try! JSONSerialization.data(withJSONObject: mockJson, options: .prettyPrinted)
        
        let mimeType = "application/json"
        let mockResponseType: Response.Type? = nil
        
        //act
        let response = ResponseFactory.createResponse(withData: mockData, mimeType: mimeType, responseType: mockResponseType)
        
        //assert
        XCTAssertTrue(response is JSONResponse)
        XCTAssertNotNil((response as? JSONResponse)?.json)
        
    }
    
    func testImageResponseCreationOnTypeSuccess() {
        
        //arrange
        let mockImage = getMockImage(color: .black, size: CGSize(width: 200, height: 200))
        let mockData = (mockImage?.pngData())!
        
        let mockMimeType: String? = nil
        let responseType = ImageResponse.self
        
        //act
        let response = ResponseFactory.createResponse(withData: mockData, mimeType: mockMimeType, responseType: responseType)
        
        //assert
        XCTAssertTrue(response is ImageResponse)
        XCTAssertNotNil((response as? ImageResponse)?.image)
        
    }
    
    func testImageResponseCreationOnMimeTypeSuccess() {
        
        //arrange
        let mockImage = getMockImage(color: .black, size: CGSize(width: 200, height: 200))
        let mockData = (mockImage?.pngData())!
        
        let mimeType = "image/png"
        let mockResponseType: Response.Type? = nil
        
        //act
        let response = ResponseFactory.createResponse(withData: mockData, mimeType: mimeType, responseType: mockResponseType)
        
        //assert
        XCTAssertTrue(response is ImageResponse)
        XCTAssertNotNil((response as? ImageResponse)?.image)
        
    }
    
}

//MARK: - Mocks
extension ResponseFactoryTests {
    
    private func getMockImage(color: UIColor, size: CGSize) -> UIImage? {
        
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        return UIImage(cgImage: cgImage)
        
    }
    
}

