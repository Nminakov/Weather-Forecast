//
//  Api.swift
//  Weather Forecast
//
//  Created by Никита on 12/09/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation

typealias ResultResponse = Result<Response, Error>

enum APIErrors: Error {
    case badStatusCode
    case emptyData
    case cannotMapModel
}

class API: NSObject {
    
    var sessionConfig: URLSessionConfiguration
    
    override init() {
        self.sessionConfig = URLSessionConfiguration.default
        super.init()
    }
    
    func fetchData(callback: @escaping (ResultResponse) -> Void) {
        let urlString = APIValue.baseUrl.appending(APIValue.Points.onecall.rawValue)
        guard
            var url = URL(string: urlString) else {
                return
        }
        let requestModel = Request(exclude: "minutely", units: "metric", lang: "ru")
        
        let urlParams = [
            "lat": requestModel.lat,
            "lon": requestModel.lon,
            "exclude": requestModel.exclude,
            "appid": requestModel.appid,
            "units": requestModel.units,
            "lang": requestModel.lang
        ]
        url = url.appendingQueryParameters(urlParams)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = APIValue.Methods.get.rawValue
        
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                callback(.failure(error))
                return
            }
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    callback(.failure(APIErrors.badStatusCode))
                    return
            }
            guard
                let data = data else {
                    callback(.failure(APIErrors.emptyData))
                    return
            }
            
            do {
                let model = try JSONDecoder().decode(Response.self, from: data)
                callback(.success(model))
            }
            catch {
                callback(.failure(APIErrors.cannotMapModel))
            }
            
        }
        task.resume()
        session.finishTasksAndInvalidate()
        
    }
    
  
    
}

protocol URLQueryParameterStringConvertible {
    var gueryParameters: String { get }
}

extension Dictionary: URLQueryParameterStringConvertible {
    var gueryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part)
        }
        return parts.joined(separator: "&")
    }
}

extension URL {
    func appendingQueryParameters(_ parametersDictionary: Dictionary<String, String>) -> URL {
        let urlString: String = String(format: "%@?%@", self.absoluteString, parametersDictionary.gueryParameters)
        return URL(string: urlString)!
    }
}
