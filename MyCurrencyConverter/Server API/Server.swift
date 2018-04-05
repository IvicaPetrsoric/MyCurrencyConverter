//
//  Service.swift
//  MyCurrencyConverter
//
//  Created by Ivica Petrsoric on 04/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import Foundation

class Server {
    
    private let baseURL = "http://hnbex.eu/api/v1/rates/daily/"
    
    
    func fetchCurrencyData(completion: @escaping (Bool, [Currency]?) -> ()){
        guard let url = URL(string: baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                print("Error fetch: ", error)

                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                print("Server response: \(httpStatus.statusCode)")
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String:AnyObject]]
                
                guard let json = jsonData else { return }
                
                var fethedData = [Currency]()
                
                for object in json {
                    let newData = Currency(dictionary: object)
                    fethedData.append(newData)
                }
                
                DispatchQueue.main.async {
                    completion(true, fethedData)
                }
                
            } catch let error{
                print("Bard parsing: ", error)
            }
        }.resume()
    }
    
}
