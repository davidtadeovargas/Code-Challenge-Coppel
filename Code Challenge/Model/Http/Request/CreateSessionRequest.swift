//
//  CreateSessionRequest.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import Foundation


class CreateSessionRequest {

    var requestToken:String
    private var onSuccess: ((_ createSessionResponse: CreateSessionResponse?) -> ())?
    private var onError: ((_ error: Error?) -> ())?
    
    init(requestToken: String,
         onSuccess: ((_ createSessionResponse: CreateSessionResponse?) -> ())?,
         onError:((_ error: Error?) -> ())?) {
        self.requestToken = requestToken
        self.onSuccess = onSuccess
        self.onError = onError
    }
    
    func request(){
     
        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer " + Constants.ACCESS_TOKEN_AUTH
        ]
        
        let parameters = ["request_token": self.requestToken] as [String : Any]

        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: Constants.BASE_URL + Constants.CREATE_SESSION_ENDPOINT)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            if let error = error {
                // Manejar el error aquí, por ejemplo, imprimirlo
                print(error.localizedDescription)
                onError!(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let createRequestResponse = try decoder.decode(CreateSessionResponse.self, from: data)
                        // Manejar createRequestResponse según tus necesidades
                        print(createRequestResponse)
                        onSuccess!(createRequestResponse)
                    } catch {
                        // Manejar errores de decodificación JSON aquí
                        print(String(localized: "error_decodificar_json") + ": \(error.localizedDescription)")
                    }
                }
            }
        })
        dataTask.resume()
    }
}
