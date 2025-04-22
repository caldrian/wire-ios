//
// Wire
// Copyright (C) 2025 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation
import WireAPI


struct FeatureConfigUpdateEvent: Equatable, Codable, Sendable {

    let featureConfig: StoredFeatureConfig

}

enum StoredFeatureConfig: Equatable, Codable, Sendable {

    case appLock(StoredAppLockFeatureConfig)
    case classifiedDomains(StoredClassifiedDomainsFeatureConfig)
    case conferenceCalling(StoredConferenceCallingFeatureConfig)
    case conversationGuestLinks(StoredBasicFeatureConfig)
    case digitalSignature(StoredBasicFeatureConfig)
    case endToEndIdentity(StoredEndToEndIdentityFeatureConfig)
    case fileSharing(StoredBasicFeatureConfig)
    case mls(StoredMLSFeatureConfig)
    case mlsMigration(StoredMLSMigrationFeatureConfig)
    case selfDeletingMessages(StoredSelfDeletingMessagesFeatureConfig)
    case channels(StoredChannelsFeatureConfig)
    case unknown(featureName: String)

}

struct StoredAppLockFeatureConfig: Codable, Equatable, Sendable {

    let status: FeatureConfigStatus
    let isMandatory: Bool
    let inactivityTimeoutInSeconds: UInt

}


enum FeatureConfigStatus: String, Codable, Sendable {

    case enabled
    case disabled

}

struct StoredClassifiedDomainsFeatureConfig: Equatable, Codable, Sendable {

    let status: FeatureConfigStatus
    let domains: [String]

}

struct StoredConferenceCallingFeatureConfig: Codable, Equatable, Sendable {

    let status: FeatureConfigStatus
    let useSFTForOneToOneCalls: Bool

}

struct StoredBasicFeatureConfig: Codable, Equatable, Sendable {

    let status: FeatureConfigStatus

}

struct StoredEndToEndIdentityFeatureConfig: Equatable, Codable, Sendable {

    let status: FeatureConfigStatus
    let acmeDiscoveryURL: String?
    let verificationExpiration: UInt
    let crlProxy: String?
    let useProxyOnMobile: Bool

}

struct StoredMLSFeatureConfig: Equatable, Codable, Sendable {

    let status: FeatureConfigStatus
    let protocolToggleUsers: [UUID]
    let defaultProtocol: MessageProtocol
    let allowedCipherSuites: [MLSCipherSuite]
    let defaultCipherSuite: MLSCipherSuite
    let supportedProtocols: [MessageProtocol]

}

struct StoredMLSMigrationFeatureConfig: Equatable, Codable, Sendable {

    let status: FeatureConfigStatus
    let startTime: Date?
    let finaliseRegardlessAfter: Date?

}

struct StoredSelfDeletingMessagesFeatureConfig: Equatable, Codable, Sendable {

    let status: FeatureConfigStatus
    let enforcedTimeoutSeconds: UInt

}

struct StoredChannelsFeatureConfig: Codable, Equatable, Sendable {

    let status: FeatureConfigStatus
    let allowedToCreateChannels: ChannelsPermision
    let allowedToOpenChannels: ChannelsPermision

}

enum StoredChannelsPermision: String, Codable, Sendable {

    case teamMembers
    case everyone
    case admins

    init(value: ChannelsPermision) {
        self = switch value {
        case .teamMembers:
            .teamMembers
        case .everyone:
            .everyone
        case .admins:
            .admins
        }
    }

}
