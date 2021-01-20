//
//  InfoPlist.swift
//  UsersDefault
//
//  Created by Amine Bensalah on 12/12/2019.
//  Copyright © 2019 Amine Bensalah. All rights reserved.
//

import Foundation

@propertyWrapper
public struct InfoDotPlist<T> {
    public var key: InfoDotPlistKey
    public var bundle: Bundle

    public init(key: InfoDotPlistKey, bundle: Bundle = .main) {
        self.key = key
        self.bundle = bundle
    }

    public var wrappedValue: T? {
        bundle.object(forInfoDictionaryKey: key.rawValue) as? T
    }
}

public struct InfoDotPlistKey: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension InfoDotPlistKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        rawValue = value
    }
}

extension InfoDotPlistKey {
    public static let version: InfoDotPlistKey = "CFBundleShortVersionString"
    public static let buildNumber: InfoDotPlistKey = "CFBundleVersion"
    public static let darkMode: InfoDotPlistKey = "UIUserInterfaceStyle"
}
