//
//  Service.swift
//  BetterStore
//
//  Created by new on 12/24/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import Foundation

class Service {
    
    static let shared = Service() // singleton
    
    func fetchApps(completion: @escaping ([Result]) -> ()) {
        print("Fetching itunes apps from Service layer")
        
        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, resp, err) in
           
            // failure
            if let err = err {
               print("Failed to fech apps: ", err)
               return
            }

            // success
            guard let data = data else { return }

            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                print(searchResult)
                
                completion(searchResult.results)
            } catch let jsonError {
               print("Failed to decode json: ", jsonError)
            }
        }.resume()
    }
}
