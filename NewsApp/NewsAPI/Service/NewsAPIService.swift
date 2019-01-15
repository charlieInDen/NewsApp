
import Foundation


typealias ContactServiceCallback = (_ data: Data?, _ error: Error?) -> Void
protocol NewsAPIService {
    func makeRequest(forRequestURL url: String,
                      andCallback callback: @escaping ContactServiceCallback)
}
enum NewsAPIServiceError: Error {
    case invalidURL
    case invalidData
    case none
}
enum BaseURL :String { // enum with type
    case newsAPI = "https://newsapi.org"
    case none
}
class NewsAPIServiceImpl: NewsAPIService {
    func makeRequest(forRequestURL urlStr: String,
                       andCallback callback: @escaping ContactServiceCallback) {
        // Make it look like method needs some time to communicate with the server
        //Read data from URL
        guard let url = URL.init(string: BaseURL.newsAPI.rawValue + urlStr) else {
            print("invalid url")
            callback(nil, NewsAPIServiceError.invalidURL)
            return
        }
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("f879d16dbb0c466d9fb33cde13e0696c", forHTTPHeaderField: "x-api-key")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
            }
            guard let jsonData = data else {
                print("invalid data")
                callback(nil, NewsAPIServiceError.invalidData)
                return
            }
            callback(jsonData, NewsAPIServiceError.none)
            }.resume()
    }
    
    
}
