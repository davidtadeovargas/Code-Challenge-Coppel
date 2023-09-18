//
//  Constants.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import Foundation

struct Constants {
    static let ACCESS_TOKEN_AUTH = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZmMzM2ZjZWU4NzBlZTE3NDU0Yjk0Zjg0NTM4MDJmZiIsInN1YiI6IjY0ZmZkMWQ3MGJiMDc2MDBhYjI4NTU2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.kvFy8tZAMPmrSbEpyok4gnLAQSuOP_wG2ONu3tSmIpM"
    
    static let BASE_URL = "https://api.themoviedb.org/3/"
    
    static let BASE_AUTHENTICATE_URL = "https://www.themoviedb.org/authenticate/"
    static let CREATE_SESSION_ENDPOINT = "authentication/session/new"
    static let CREATE_REQUEST_TOKEN_ENDPOINT = "authentication/token/new"
    static let MOVIE_POPULAR_ENDPOINT = "movie/popular?language=en-US&page="
    static let MOVIE_TOP_RATED_ENDPOINT = "movie/top_rated?language=en-US&page="
    static let MOVIE_ON_TV_ENDPOINT = "movie/upcoming?language=en-US&page="
    static let MOVIE_AIRING_TODAY_ENDPOINT = "movie/now_playing?language=en-US&page="
    static let MOVIE_IMAGES_ENDPOINT = "https://image.tmdb.org/t/p/w200/"
    static let MOVIE_USER_DETAILS_ENDPOINT = "account/"
}
