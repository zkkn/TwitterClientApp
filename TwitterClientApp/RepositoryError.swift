//
//  RepositoryError.swift
//  TwitterClientApp
//
//  Created by Shoichi Kanzaki on 2017/06/29.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import Foundation

enum RepositoryError: Error {
    case failedToDeserialize
    case notFound
}
