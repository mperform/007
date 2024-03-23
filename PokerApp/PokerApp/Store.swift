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
}
