//
//  ResultsResponse.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import Foundation

struct ResultsResponse : Decodable {
    var page:Int32
    var results:[ResultResponse]
    var total_pages:Int32
    var total_results:Int32
}
