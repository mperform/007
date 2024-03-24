import Foundation
import Observation
import UIKit
import Alamofire

@Observable
final class ImageStore {
    static let shared = ImageStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    private (set) var yourCards: String = ""
    private (set) var yourCommunityCards: String = ""
    private (set) var yourFinalCards: [String] = []
    private (set) var yourFinalCommunityCards: [String] = []
    private (set) var bestHand: String = ""
    private let serverUrl = "https://18.117.138.137/"
    
    func getHand() {
        guard let apiUrl = URL(string: "\(serverUrl)gethand/") else {
            print("gethand: bad URL")
            return
        }
        
        AF.request(apiUrl, method: .get).responseData { response in
            guard let data = response.data, response.error == nil else {
                print("gethand: NETWORKING ERROR")
                return
            }
            if let httpStatus = response.response, httpStatus.statusCode != 200 {
                print("gethand: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("gethand: failed JSON deserialization")
                return
            }
            let cardsReceived = jsonObj["cards"] as? [String] ?? []
            self.yourCards = ""
            for entry in cardsReceived {
                if (entry == cardsReceived.last) {
                    self.yourCards += entry
                }
                else {
                    self.yourCards += entry + ", "
                }
            }
//            print(self.yourCards)
        }
    }
    
    func postHand(image: UIImage?) async -> Data? {
        guard let apiUrl = URL(string: "\(serverUrl)posthand/") else {
            print("posthand: Bad URL")
            return nil
        }
                
        return try? await AF.upload(multipartFormData: { mpFD in
            if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
                mpFD.append(jpegImage, withName: "image", fileName: "handImage", mimeType: "image/jpeg")
            }
        }, to: apiUrl, method: .post).validate().serializingData().value
    }
    
    
    func getCommunityCards() {
        guard let apiUrl = URL(string: "\(serverUrl)getcommunitycards/") else {
            print("getcommunitycards: bad URL")
            return
        }
        
        AF.request(apiUrl, method: .get).responseData { response in
            guard let data = response.data, response.error == nil else {
                print("getcommunitycards: NETWORKING ERROR")
                return
            }
            if let httpStatus = response.response, httpStatus.statusCode != 200 {
                print("getcommunitycards: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getcommunitycards: failed JSON deserialization")
                return
            }
            let cardsReceived = jsonObj["cards"] as? [String] ?? []
            self.yourCommunityCards = ""
            for entry in cardsReceived {
                if (entry == cardsReceived.last) {
                    self.yourCommunityCards += entry
                }
                else {
                    self.yourCommunityCards += entry + ", "
                }
            }
//            print(self.yourCommunityCards)
        }
    }
    
    func postCommunityCards(image: UIImage?) async -> Data? {
        guard let apiUrl = URL(string: "\(serverUrl)postcommunitycards/") else {
            print("postcommunitycards: Bad URL")
            return nil
        }
                
        return try? await AF.upload(multipartFormData: { mpFD in
            if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
                mpFD.append(jpegImage, withName: "image", fileName: "commImage", mimeType: "image/jpeg")
            }
        }, to: apiUrl, method: .post).validate().serializingData().value
    }
    
    func postfinalhand(_ hand: String, completion: @escaping () -> ()) {
        let jsonObj = ["cards":hand]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postfinalhand: jsonData serialization error")
            return
        }
                
        guard let apiUrl = URL(string: "\(serverUrl)postfinalhand/") else {
            print("postfinalhand: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print("postfinalhand: NETWORKING ERROR")
                return
            }

            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    print("postfinalhand: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                } else {
                    completion()
                }
            }

        }.resume()
    }
    
    func postfinalcommunitycards(_ cards: String, completion: @escaping () -> ()) {
        let jsonObj = ["cards":cards]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postfinalcommunitycards: jsonData serialization error")
            return
        }
                
        guard let apiUrl = URL(string: "\(serverUrl)postfinalcommunitycards/") else {
            print("postfinalcommunitycards: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print("postfinalcommunitycards: NETWORKING ERROR")
                return
            }

            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    print("postfinalcommunitycards: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                } else {
                    completion()
                }
            }

        }.resume()
    }
    
    func postmoney(_ useramount: String, _ callamount: String, completion: @escaping () -> ()) {
        let jsonObj = ["useramount": useramount,
                       "callamount": callamount]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postmoney: jsonData serialization error")
            return
        }
                
        guard let apiUrl = URL(string: "\(serverUrl)postmoney/") else {
            print("postmoney: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print("postmoney: NETWORKING ERROR")
                return
            }

            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    print("postmoney: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                } else {
                    completion()
                }
            }

        }.resume()
    }
    
    func getFinalHand(completion: @escaping () -> ()) {
        guard let apiUrl = URL(string: "\(serverUrl)getfinalhand/") else {
            print("gethand: bad URL")
            return
        }
        
        AF.request(apiUrl, method: .get).responseData { response in
            guard let data = response.data, response.error == nil else {
                print("getfinalhand: NETWORKING ERROR")
                return
            }
            if let httpStatus = response.response, httpStatus.statusCode != 200 {
                print("getfinalhand: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getfinalhand: failed JSON deserialization")
                return
            }
            let cardsReceived = jsonObj["cards"] as? [String] ?? []
            self.yourFinalCards = []
            for entry in cardsReceived {
                self.yourFinalCards.append(entry)
            }
            completion()
        }
        
    }
    
    func getFinalCommunityCards(completion: @escaping () -> ()) {
        guard let apiUrl = URL(string: "\(serverUrl)getfinalcommunitycards/") else {
            print("getfinalcommunitycards: bad URL")
            return
        }
        
        AF.request(apiUrl, method: .get).responseData { response in
            guard let data = response.data, response.error == nil else {
                print("getfinalcommunitycards: NETWORKING ERROR")
                return
            }
            if let httpStatus = response.response, httpStatus.statusCode != 200 {
                print("getfinalcommunitycards: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getfinalcommunitycards: failed JSON deserialization")
                return
            }
            let cardsReceived = jsonObj["cards"] as? [String] ?? []
            self.yourFinalCommunityCards = []
            for entry in cardsReceived {
                self.yourFinalCommunityCards.append(entry)
            }
            completion()
        }
    }
    
    func getBestHand(completion: @escaping () -> ()) {
        guard let apiUrl = URL(string: "\(serverUrl)getbesthand/") else {
            print("getfinalcommunitycards: bad URL")
            return
        }
        
        AF.request(apiUrl, method: .get).responseData { response in
            guard let data = response.data, response.error == nil else {
                print("getbesthand: NETWORKING ERROR")
                return
            }
            if let httpStatus = response.response, httpStatus.statusCode != 200 {
                print("getbesthand: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getbesthand: failed JSON deserialization")
                return
            }
            let handReceived = jsonObj["best_hand"] as? String ?? ""
            self.bestHand = handReceived
            completion()
        }
    }

}
