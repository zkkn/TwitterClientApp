//
//  BuildOAuth1SwiftService.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/20.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import OAuthSwift

struct BuildOAuth1SwiftService {
    
    static var oauthswift = OAuth1Swift(
        consumerKey: "Q8Zwi892fPBvAWLIxYP1YtlTQ",
        consumerSecret: "uoUD6JLzxnvJG20vncmbZ13jYfgt4CQ50HZIVMENqCFYfQDGyc",
        requestTokenUrl: "https://api.twitter.com/oauth/request_token",
        authorizeUrl:    "https://api.twitter.com/oauth/authorize",
        accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
    )
}
