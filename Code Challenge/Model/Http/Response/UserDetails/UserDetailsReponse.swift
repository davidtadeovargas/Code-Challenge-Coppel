//
//  UserDetailsReponse.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 18/09/23.
//

import Foundation

struct UserDetailsResponse: Decodable {
    var avatar: AvatarResponse
    var id: Int
    var iso_639_1: String
    var iso_3166_1: String
    var name: String
    var include_adult: Bool
    var username: String
}

struct AvatarResponse: Decodable {
    var gravatar: GravatarResponse
    var tmdb: TmdbResponse
}

struct GravatarResponse: Decodable {
    var hash: String
}

struct TmdbResponse: Decodable {
    var avatar_path: String?
}

