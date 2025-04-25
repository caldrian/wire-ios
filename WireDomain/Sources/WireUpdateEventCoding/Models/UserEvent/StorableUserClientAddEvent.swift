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


struct UserClientAddEvent: Equatable, Codable, Sendable {

    private let client: StorableSelfUserClient

}

// MARK: - Private models

private struct StorableSelfUserClient: Equatable, Identifiable, Codable, Sendable {

    let id: String
    let type: UserClientType
    let activationDate: Date
    let label: String?
    let model: String?
    let deviceClass: DeviceClass?
    let lastActiveDate: Date?
    let mlsPublicKeys: MLSPublicKeys?
    let cookie: String?
    let capabilities: [UserClientCapability]

}


private enum DeviceClass: String, Codable, Sendable {

    case phone
    case tablet
    case desktop
    case legalhold

}


private struct MLSPublicKeys: Equatable, Codable, Sendable {

    let ed25519: String?
    let ed448: String?
    let p256: String?
    let p384: String?
    let p512: String?

}

private enum UserClientCapability: String, Codable, Sendable {

    case legalholdConsent
    case consumableNotifications

}

private enum UserClientType: String, Codable, Sendable {

    case permanent
    case temporary
    case legalhold

}
