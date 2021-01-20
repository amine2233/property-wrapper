//
//  UserDefault.swift
//  UsersDefault
//
//  Created by Amine Bensalah on 11/12/2019.
//  Copyright © 2019 Amine Bensalah. All rights reserved.
//

import Foundation
import FoundationExtension

public protocol PropertyListValue {}

@propertyWrapper
public struct UserDefault<T: PropertyListValue> {
    public let key: Key
    public let defaultValue: T
    private(set) var userDefaults: UserDefaults

    public var projectedValue: UserDefault<T> { self }

    public init(key: Key, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: T {
        get { userDefaults.object(forKey: key.rawValue) as? T ?? defaultValue }
        set { userDefaults.set(newValue, forKey: key.rawValue) }
    }

    public func observe(change: @escaping (T?) -> Void) -> Disposable {
        DefaultsObservation(key: key, userDefaults: userDefaults, onChange: change).configure()
    }
}

public struct Key: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Key: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        rawValue = value
    }
}

extension Data: PropertyListValue {}
extension NSData: PropertyListValue {}

extension String: PropertyListValue {}
extension NSString: PropertyListValue {}

extension Date: PropertyListValue {}
extension NSDate: PropertyListValue {}

extension NSNumber: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Int8: PropertyListValue {}
extension Int16: PropertyListValue {}
extension Int32: PropertyListValue {}
extension Int64: PropertyListValue {}
extension UInt: PropertyListValue {}
extension UInt8: PropertyListValue {}
extension UInt16: PropertyListValue {}
extension UInt32: PropertyListValue {}
extension UInt64: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}

extension Key {
    public static let isFirstLaunch: Key = "isFirstLaunch"
}

final class DefaultsObservation<T: PropertyListValue>: NSObject, Disposable {
    let key: Key
    private var onChange: (T?) -> Void
    var isDisposed: Bool = false
    var userDefaults: UserDefaults

    init(key: Key, userDefaults: UserDefaults = .standard, onChange: @escaping (T?) -> Void) {
        self.key = key
        self.onChange = onChange
        self.userDefaults = userDefaults
    }

    func configure() -> DefaultsObservation<T> {
        userDefaults.addObserver(self, forKeyPath: key.rawValue, options: [.new], context: nil)
        return self
    }

    // swiftlint:disable block_based_kvo
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == key.rawValue else { return }
        onChange(change[.newKey] as? T)
    }

    // swiftlint:enable block_based_kvo

    func dispose() {
        if !isDisposed {
            userDefaults.removeObserver(self, forKeyPath: key.rawValue, context: nil)
            isDisposed = true
        }
    }
}
