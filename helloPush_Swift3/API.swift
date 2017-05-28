//
//  API.swift
//  helloPush_Swift3
//
//  Created by Tomas Pecuch on 27/05/2017.
//  Copyright © 2017 Ananth. All rights reserved.
//

import Foundation
import Alamofire

protocol APIAdapterDelegate: class {
    func didLoadMessage(message: String)
}

class APIAdapter {
    
    static let sharedInstance = APIAdapter()
    
    weak var delegate: APIAdapterDelegate?

    // MARK: - Properties

    var name = UIDevice.current.name
    var messagesArray = [String]()

    // MARK: - Actions

    func getMessages() {
        Alamofire.request("http://imfpush.eu-gb.bluemix.net/imfpush/v1/apps/02bfd12b-9df3-4283-aecc-661b2abb77a2/messages", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["appSecret" : "eb8af3a3-35c2-47ca-96cf-2437b839dedf"])
            .responseJSON { response in
                //                print(response.request as Any)  // original URL request
                //                print(response.response as Any) // URL response
                //                print(response.result.value as Any)   // result of response serialization
                if let messages = response.result.value as? [String : Any] {
                    for message in messages {
                        if message.key == "messages" {
                            if let array = message.value as? [[String : Any]] {
                                print(array)
                                for message in array {
                                    let mesID = message["messageId"] as! String
                                    self.getMessage(id: mesID)
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func getMessage(id: String) {
        Alamofire.request("http://imfpush.eu-gb.bluemix.net/imfpush/v1/apps/02bfd12b-9df3-4283-aecc-661b2abb77a2/messages/\(id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["appSecret" : "eb8af3a3-35c2-47ca-96cf-2437b839dedf"])
            .responseJSON { response in
                //                print(response.request as Any)  // original URL request
                //                print(response.response as Any) // URL response
                //print(response.result.value as Any)   // result of response serialization
                if let messages = response.result.value as? [String : Any] {
                    if let mes = messages["message"] as? [String : Any] {
                        let alert = mes["alert"] as! String
                        print("alert: \(alert)")
                        self.messagesArray.append(alert)
                        if let del = self.delegate {
                            del.didLoadMessage(message: alert)
                        }
                    }
                }
        }
    }
    
    func postMessage(text: String) {
        let headers = [
            "appSecret" : "eb8af3a3-35c2-47ca-96cf-2437b839dedf",
            "Accept-Language" : "en-US",
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        ]
        let params = [
            "message" : ["alert" : "\(name): \(text), \(self.getDate())"]
        ]

        Alamofire.request("http://imfpush.eu-gb.bluemix.net/imfpush/v1/apps/02bfd12b-9df3-4283-aecc-661b2abb77a2/messages", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print("😂 printing post response 😂😂😂😂😂😂😂😂")
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
        }
    }

    // MARK: - Helpers
    
    private func getDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
    }
}
