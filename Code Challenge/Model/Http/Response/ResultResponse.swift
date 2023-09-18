//
//  ResultResponse.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import Foundation

struct ResultResponse:Decodable{
    var adult:Bool
    var backdrop_path:String
    var genre_ids:[Int32]
    var id:Int32
    var original_language:String
    var original_title:String
    var overview:String
    var popularity:Double
    var poster_path:String
    var release_date:String
    var title:String
    var video:Bool
    var vote_average:Double
    var vote_count:Int32
}
