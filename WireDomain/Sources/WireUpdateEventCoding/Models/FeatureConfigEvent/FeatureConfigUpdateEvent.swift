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

    private let featureConfig: Stored.FeatureConfig

    init(_ value: WireAPI.FeatureConfigUpdateEvent) {
        self.featureConfig = switch value.featureConfig {
        case let .appLock(config):
                .appLock(
                    Stored.AppLockFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        isMandatory: config.isMandatory,
                        inactivityTimeoutInSeconds: config.inactivityTimeoutInSeconds
                    )
                )
        case let .classifiedDomains(config):
                .classifiedDomains(
                    Stored.ClassifiedDomainsFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        domains: Array(config.domains)
                    )
                )
        case let .conferenceCalling(config):
                .conferenceCalling(
                    Stored.ConferenceCallingFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        useSFTForOneToOneCalls: config.useSFTForOneToOneCalls
                    )
                )
        case let .conversationGuestLinks(config):
                .conversationGuestLinks(
                    Stored.BasicFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status)
                    )
                )
        case let .digitalSignature(config):
                .digitalSignature(
                    Stored.BasicFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status)
                    )
                )
        case let .endToEndIdentity(config):
                .endToEndIdentity(
                    Stored.EndToEndIdentityFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        acmeDiscoveryURL: config.acmeDiscoveryURL,
                        verificationExpiration: config.verificationExpiration,
                        crlProxy: config.crlProxy,
                        useProxyOnMobile: config.useProxyOnMobile
                    )
                )
        case let .fileSharing(config):
                .fileSharing(
                    Stored.BasicFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status)
                    )
                )
        case let .mls(config):
                .mls(
                    Stored.MLSFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        protocolToggleUsers: Array(config.protocolToggleUsers),
                        defaultProtocol: Stored.MessageProtocol(config.defaultProtocol),
                        allowedCipherSuites: config.allowedCipherSuites.map { Stored.MLSCipherSuite($0) },
                        defaultCipherSuite: Stored.MLSCipherSuite(config.defaultCipherSuite),
                        supportedProtocols: config.supportedProtocols.map { Stored.MessageProtocol($0) }
                    )
                )
        case let .mlsMigration(config):
            // FIXME: There is a compiler crash :(
            fatalError()
//                .mlsMigration(
//                    Stored.MLSMigrationFeatureConfig(
//                        status: Stored.FeatureConfigStatus(config.status),
//                        startTime: config.startTime,
//                        finaliseRegardlessAfter: config.finaliseRegardlessAfter
//                    )
//                )
        case let .selfDeletingMessages(config):
                .selfDeletingMessages(
                    Stored.SelfDeletingMessagesFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        enforcedTimeoutSeconds: config.enforcedTimeoutSeconds
                    )
                )
        case let .channels(config):
                .channels(
                    Stored.ChannelsFeatureConfig(
                        status: Stored.FeatureConfigStatus(config.status),
                        allowedToCreateChannels: Stored.ChannelsFeatureConfig.Permission(config.allowedToCreateChannels),
                        allowedToOpenChannels: Stored.ChannelsFeatureConfig.Permission(config.allowedToOpenChannels)
                    )
                )
        case let .unknown(featureName):
            .unknown(featureName: featureName)
        }
    }

}

// MARK: Private Models

private extension Stored {

    enum FeatureConfig: Equatable, Codable, Sendable {

        case appLock(Stored.AppLockFeatureConfig)
        case classifiedDomains(Stored.ClassifiedDomainsFeatureConfig)
        case conferenceCalling(Stored.ConferenceCallingFeatureConfig)
        case conversationGuestLinks(Stored.BasicFeatureConfig)
        case digitalSignature(Stored.BasicFeatureConfig)
        case endToEndIdentity(Stored.EndToEndIdentityFeatureConfig)
        case fileSharing(Stored.BasicFeatureConfig)
        case mls(Stored.MLSFeatureConfig)
        case mlsMigration(Stored.MLSMigrationFeatureConfig)
        case selfDeletingMessages(Stored.SelfDeletingMessagesFeatureConfig)
        case channels(Stored.ChannelsFeatureConfig)
        case unknown(featureName: String)

    }

    // MARK: Shared

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

    // MARK: Feature configs

    struct BasicFeatureConfig: Codable, Equatable, Sendable {

        let status: Stored.FeatureConfigStatus

    }

    struct AppLockFeatureConfig: Codable, Equatable, Sendable {

        let status: Stored.FeatureConfigStatus
        let isMandatory: Bool
        let inactivityTimeoutInSeconds: UInt

    }

    struct ClassifiedDomainsFeatureConfig: Equatable, Codable, Sendable {

        let status: Stored.FeatureConfigStatus
        let domains: [String]

    }

    struct ConferenceCallingFeatureConfig: Codable, Equatable, Sendable {

        let status: Stored.FeatureConfigStatus
        let useSFTForOneToOneCalls: Bool

    }

    struct EndToEndIdentityFeatureConfig: Equatable, Codable, Sendable {

        let status: Stored.FeatureConfigStatus
        let acmeDiscoveryURL: String?
        let verificationExpiration: UInt
        let crlProxy: String?
        let useProxyOnMobile: Bool

    }

    struct MLSFeatureConfig: Equatable, Codable, Sendable {

        let status: Stored.FeatureConfigStatus
        let protocolToggleUsers: [UUID]
        let defaultProtocol: Stored.MessageProtocol
        let allowedCipherSuites: [Stored.MLSCipherSuite]
        let defaultCipherSuite: Stored.MLSCipherSuite
        let supportedProtocols: [Stored.MessageProtocol]

    }

    struct MLSMigrationFeatureConfig: Equatable, Codable, Sendable {

        let status: Stored.FeatureConfigStatus
//        let startTime: Date? FIXME: Uncomment
//        let finaliseRegardlessAfter: Date? FIXME: Uncomment

    }

    struct SelfDeletingMessagesFeatureConfig: Equatable, Codable, Sendable {

        let status: Stored.FeatureConfigStatus
        let enforcedTimeoutSeconds: UInt

    }

    struct ChannelsFeatureConfig: Codable, Equatable, Sendable {

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


}

enum Stored {}

