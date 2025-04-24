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

    init(_ value: WireAPI.FeatureConfigUpdateEvent) {
        self.featureConfig = switch value.featureConfig {
        case let .appLock(config):
                .appLock(
                    StoredAppLockFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        isMandatory: config.isMandatory,
                        inactivityTimeoutInSeconds: config.inactivityTimeoutInSeconds
                    )
                )
        case let .classifiedDomains(config):
                .classifiedDomains(
                    StoredClassifiedDomainsFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        domains: Array(config.domains)
                    )
                )
        case let .conferenceCalling(config):
                .conferenceCalling(
                    StoredConferenceCallingFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        useSFTForOneToOneCalls: config.useSFTForOneToOneCalls
                    )
                )
        case let .conversationGuestLinks(config):
                .conversationGuestLinks(
                    StoredBasicFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status)
                    )
                )
        case let .digitalSignature(config):
                .digitalSignature(
                    StoredBasicFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status)
                    )
                )
        case let .endToEndIdentity(config):
                .endToEndIdentity(
                    StoredEndToEndIdentityFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        acmeDiscoveryURL: config.acmeDiscoveryURL,
                        verificationExpiration: config.verificationExpiration,
                        crlProxy: config.crlProxy,
                        useProxyOnMobile: config.useProxyOnMobile
                    )
                )
        case let .fileSharing(config):
                .fileSharing(
                    StoredBasicFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status)
                    )
                )
        case let .mls(config):
                .mls(
                    StoredMLSFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        protocolToggleUsers: Array(config.protocolToggleUsers),
                        defaultProtocol: Stored.MessageProtocol(config.defaultProtocol),
                        allowedCipherSuites: config.allowedCipherSuites.map { Stored.MLSCipherSuite($0) },
                        defaultCipherSuite: Stored.MLSCipherSuite(config.defaultCipherSuite),
                        supportedProtocols: config.supportedProtocols.map { Stored.MessageProtocol($0) }
                    )
                )
        case let .mlsMigration(config):
                .mlsMigration(
                    StoredMLSMigrationFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        startTime: config.startTime,
                        finaliseRegardlessAfter: config.finaliseRegardlessAfter
                    )
                )
        case let .selfDeletingMessages(config):
                .selfDeletingMessages(
                    StoredSelfDeletingMessagesFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        enforcedTimeoutSeconds: config.enforcedTimeoutSeconds
                    )
                )
        case let .channels(config):
                .channels(
                    StoredChannelsFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        allowedToCreateChannels: StoredChannelsFeatureConfig.Permission(config.allowedToCreateChannels),
                        allowedToOpenChannels: StoredChannelsFeatureConfig.Permission(config.allowedToOpenChannels)
                    )
                )
        case let .unknown(featureName):
            .unknown(featureName: featureName)
        }
    }

}



extension MessageProtocol {

    init(_ value: WireAPI.MessageProtocol) {
        switch value {
        case .proteus:
            self = .proteus
        case .mls:
            self = .mls
        }
    }

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

    let status: Stored.FeatureConfigStatus
    let isMandatory: Bool
    let inactivityTimeoutInSeconds: UInt

}

struct StoredClassifiedDomainsFeatureConfig: Equatable, Codable, Sendable {

    let status: Stored.FeatureConfigStatus
    let domains: [String]

}

struct StoredConferenceCallingFeatureConfig: Codable, Equatable, Sendable {

    let status: Stored.FeatureConfigStatus
    let useSFTForOneToOneCalls: Bool

}

struct StoredBasicFeatureConfig: Codable, Equatable, Sendable {

    let status: Stored.FeatureConfigStatus

}

struct StoredEndToEndIdentityFeatureConfig: Equatable, Codable, Sendable {

    let status: Stored.FeatureConfigStatus
    let acmeDiscoveryURL: String?
    let verificationExpiration: UInt
    let crlProxy: String?
    let useProxyOnMobile: Bool

}

struct StoredMLSFeatureConfig: Equatable, Codable, Sendable {

    let status: Stored.FeatureConfigStatus
    let protocolToggleUsers: [UUID]
    let defaultProtocol: Stored.MessageProtocol
    let allowedCipherSuites: [Stored.MLSCipherSuite]
    let defaultCipherSuite: Stored.MLSCipherSuite
    let supportedProtocols: [Stored.MessageProtocol]

}

struct StoredMLSMigrationFeatureConfig: Equatable, Codable, Sendable {

    let status: Stored.FeatureConfigStatus
    let startTime: Date?
    let finaliseRegardlessAfter: Date?

}

struct StoredSelfDeletingMessagesFeatureConfig: Equatable, Codable, Sendable {

    let status: Stored.FeatureConfigStatus
    let enforcedTimeoutSeconds: UInt

}

struct StoredChannelsFeatureConfig: Codable, Equatable, Sendable {

    enum Permission: String, Codable, Sendable {

        case teamMembers
        case everyone
        case admins

        init(_ value: WireAPI.ChannelsPermision) {
            switch value {
            case .teamMembers:
                self = .teamMembers
            case .everyone:
                self = .everyone
            case .admins:
                self = .admins
            }
        }

    }

    let status: Stored.FeatureConfigStatus
    let allowedToCreateChannels: Permission
    let allowedToOpenChannels: Permission

}



enum Stored {

    enum FeatureConfigStatus: String, Codable, Sendable {

        case enabled
        case disabled

        init(_ value: WireAPI.FeatureConfigStatus) {
            switch value {
            case .enabled:
                self = .enabled
            case .disabled:
                self = .disabled
            }
        }

    }

}
