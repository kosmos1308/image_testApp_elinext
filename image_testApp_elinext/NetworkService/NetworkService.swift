//
//  NetworkService.swift
//  image_testApp_elinext
//
//  Created by pavel on 15.07.21.
//

import Foundation

class NetworkService {
    
    func request(urlString: String, completion: @escaping (Result<Image, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                do {
                    let nameImage = try JSONDecoder().decode(Image.self, from: data)
                    completion(.success(nameImage))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            }
        }.resume()
    }
}
