//
//  ReachablityManager.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 13/05/2026.
//

import Foundation
import SystemConfiguration

final class ReachabilityManager {
    static let shared = ReachabilityManager()
    private init() {}

    var isConnected: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else { return false }

        var flags: SCNetworkReachabilityFlags = []
        guard SCNetworkReachabilityGetFlags(reachability, &flags) else { return false }

        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
}
