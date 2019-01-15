//
//  ContactMainViewModel.swift
//  SampleTestApp
//
//  Created by Nishant Sharma on 1/8/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation
typealias FetchDataCallback = (Error?) -> Void
final class NewsMainViewModel {
    let newsService: NewsAPIService
    var newsData: [Article] = []
    var data: [Article]?
    var totalPage: Int = 0
    var currentPage = -1
    var numberOfItemsPerPage:Int = 20

    init(service: NewsAPIService) {
        self.newsService = service
    }
    func loadData(at page: Int, withQuery str:String,  onComplete: @escaping ([Article]) -> Void) {
        
        var urlStr = "/v2/top-headlines" + "?country=in" + "&page=" + String(page)
        if str.count > 0 {
             urlStr = urlStr + "&q=" + str
        }
        print("loadData(at page: " + String(page) + "forURL:" + urlStr + ")" )
        self.fetchData(urlStr, completionHandler: { (error) in
            DispatchQueue.main.async {
                onComplete(self.data ?? [])
            }
        })
    }
    
    func fetchData(_ urlString:String, completionHandler: @escaping FetchDataCallback){
        newsService.makeRequest(forRequestURL: urlString) { (result, error) in
            guard let jsonData = result else {
                print("jsonData in getContactList nil")
                return
            }
            
            guard let responseJson = try? JSONDecoder().decode(Result.self, from: jsonData) else {
                print("Unable to parse the json")
                completionHandler(error)
                return
            }
            self.data = responseJson.articles
            //One time count logic
            self.totalPage = (responseJson.totalResults ?? 0 )
            DispatchQueue.main.async {
                    completionHandler(error)
            }
        }
    }
}


