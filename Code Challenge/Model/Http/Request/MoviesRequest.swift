//
//  MoviePopularRequest.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import Foundation

class MoviesRequest {
    
    private var onSuccess: ((_ resultsResponse: ResultsResponse?) -> ())?
    private var onSuccessUserDetails: ((_ userDetailsResponse: UserDetailsResponse?) -> ())?
    private var onSuccessCreateRequestTokenRequest: ((_ createRequestTokenResponse: CreateRequestTokenResponse?) -> ())?
    
    private var onError: ((_ error: Error?) -> ())?
    var endpoint:String?
    
    var page:Int32 = 1
    
    init(onSuccess: ((_ resultsResponse: ResultsResponse?) -> ())?,
         onError:((_ error: Error?) -> ())?) {
        self.onSuccess = onSuccess
        self.onError = onError
    }
    
    init(onSuccessUserDetails: ((_ userDetailsResponse: UserDetailsResponse?) -> ())?,
         onError:((_ error: Error?) -> ())?) {
        self.onSuccessUserDetails = onSuccessUserDetails
        self.onError = onError
    }
    
    init(onSuccessCreateRequestTokenRequest: ((_ createRequestTokenResponse: CreateRequestTokenResponse?) -> ())?,
         onError:((_ error: Error?) -> ())?) {
        self.onSuccessCreateRequestTokenRequest = onSuccessCreateRequestTokenRequest
        self.onError = onError
    }
    
    func request(){
     
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer " + Constants.ACCESS_TOKEN_AUTH
        ]
        
        let urlFinal:String
        if endpoint==Constants.CREATE_REQUEST_TOKEN_ENDPOINT {
            urlFinal = Constants.BASE_URL + endpoint!
        } else {
            urlFinal = Constants.BASE_URL + endpoint! + String(page)
        }
        let request = NSMutableURLRequest(url: NSURL(string: urlFinal)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
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
                        
                        if let dataString = String(data: data, encoding: .utf8) {
                            // Imprime los datos en formato de cadena antes de la conversión
                            print(dataString)
                        }
        
                        let decoder = JSONDecoder()
                        
                        if  endpoint==Constants.MOVIE_POPULAR_ENDPOINT ||
                            endpoint==Constants.MOVIE_TOP_RATED_ENDPOINT ||
                            endpoint==Constants.MOVIE_ON_TV_ENDPOINT ||
                            endpoint==Constants.MOVIE_AIRING_TODAY_ENDPOINT {
                            
                            let resultsResponse = try decoder.decode(ResultsResponse.self, from: data)
                            // Manejar createRequestResponse según tus necesidades
                            print(resultsResponse)
                            onSuccess!(resultsResponse)
                            
                        } else if endpoint==Constants.MOVIE_USER_DETAILS_ENDPOINT {
                            
                            let userDetailsReponse = try decoder.decode(UserDetailsResponse.self, from: data)
                            // Manejar createRequestResponse según tus necesidades
                            print(userDetailsReponse)
                            onSuccessUserDetails!(userDetailsReponse)
                            
                        } else if endpoint==Constants.CREATE_REQUEST_TOKEN_ENDPOINT {
                            
                            let createRequestTokenResponse = try decoder.decode(CreateRequestTokenResponse.self, from: data)
                            // Manejar createRequestResponse según tus necesidades
                            print(createRequestTokenResponse)
                            onSuccessCreateRequestTokenRequest!(createRequestTokenResponse)
                        }
                    
                        
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
