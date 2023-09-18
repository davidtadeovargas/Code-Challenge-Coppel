//
//  CreateRequestTokenResponse.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import Foundation

struct CreateRequestTokenResponse:Decodable{
    var success:Bool
    var expires_at:String
    var request_token:String
}
