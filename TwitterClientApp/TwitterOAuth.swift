//
//  TwitterOAuth.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/20.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation
import OAuthSwift

class TwitterOAuth {
    
    lazy var consumerData: [String:String] = {
        return  ["consumerKey": "Q8Zwi892fPBvAWLIxYP1YtlTQ",
                 "consumerSecret": "uoUD6JLzxnvJG20vncmbZ13jYfgt4CQ50HZIVMENqCFYfQDGyc"]
    }()
    
    var data : NSMutableData? = nil
    var dataEncoding = String.Encoding.utf8
}


// MARK: - Functions -

extension TwitterOAuth {
    
    // signature作成
    func oauthSignatureForMethod(method: String, url: URL, parameters: Dictionary<String, String>) -> String {
        let signingKey : String = "\(consumerData["consumerData"])&"
        _ = signingKey.data(using: dataEncoding)
        
        // パラメータ取得してソート
        var parameterComponents = urlEncodedQueryStringWithEncoding(params: parameters).components(separatedBy: "&") as [String]
        parameterComponents.sort { $0 < $1 }
        
        // query string作成
        let parameterString = parameterComponents.joined(separator: "&")
        
        // urlエンコード
        let encodedParameterString = urlEncodedStringWithEncoding(str: parameterString)
        
        let encodedURL = urlEncodedStringWithEncoding(str: url.absoluteString)
        
        // signature用ベース文字列作成
        let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"
        _ = signatureBaseString.data(using: dataEncoding)
        
        // signature作成
        return SHA1DigestWithKey(base: signatureBaseString, key: signingKey).base64EncodedString(options: [])
    }
    
    // Dictionary内のデータをエンコード
    func urlEncodedQueryStringWithEncoding(params:Dictionary<String, String>) -> String {
        var parts = [String]()
        for (key, value) in params {
            let keyString = urlEncodedStringWithEncoding(str: key)
            let valueString = urlEncodedStringWithEncoding(str: value)
            let query = "\(keyString)=\(valueString)" as String
            parts.append(query)
        }
        return parts.joined(separator: "&") as String
    }
    
    // URLエンコード
    func urlEncodedStringWithEncoding(str: String) -> String {
        //        let charactersToBeEscaped = ":/?&=;+!@#$()',*" as CFString
        //        let charactersToLeaveUnescaped = "[]." as CFString
        //
        //        var raw: NSString = str as NSString
        //
        //        let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, raw, charactersToLeaveUnescaped, charactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(dataEncoding.rawValue)) as NSString
        //
        //        return result as String
        return str.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    // SHA1署名のハッシュ値を作成
    func SHA1DigestWithKey(base: String, key: String) -> NSData {
        let str = base.cString(using: dataEncoding)
        let strLen = UInt(base.lengthOfBytes(using: dataEncoding))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = UInt(key.lengthOfBytes(using: String.Encoding.utf8))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyStr!, Int(keyLen), str!, Int(strLen), result)
        
        return NSData(bytes: result, length: digestLen)
    }
    
    func createHeaderString(oauth_token:String) -> String {
        var param = Dictionary<String, String>()
        param["oauth_version"] = "1.0"
        param["oauth_signature_method"] = "HMAC-SHA1"
        // ConsumerKey
        param["oauth_consumer_key"] = oauth_token
        // Unixタイムスタンプ
        param["oauth_timestamp"] = String(Int64(NSDate().timeIntervalSince1970))
        // ランダムな文字列
        param["oauth_nonce"] = (NSUUID().uuidString as NSString).substring(to: 8)
        // コールバック
        param["oauth_callback"] = "oauth-swift://"
        // 証明書
        param["oauth_signature"] = oauthSignatureForMethod(method: "POST", url: URL(string: "https://api.twitter.com/oauth/request_token")!, parameters: param)
        
        // アルファベット順に並べ替える
        var authorizationParameterComponents = urlEncodedQueryStringWithEncoding(params: param).components(separatedBy: "&") as [String]
        authorizationParameterComponents.sort { $0 < $1 }
        
        // リクエスト文字列作成
        var headerComponents = [String]()
        for component in authorizationParameterComponents {
            let subcomponent = component.components(separatedBy: "=") as [String]
            if subcomponent.count == 2 {
                headerComponents.append("\(subcomponent[0])=\"\(subcomponent[1])\"")
            }
        }
        
        return "OAuth" + headerComponents.joined(separator: ",")
    }
}
