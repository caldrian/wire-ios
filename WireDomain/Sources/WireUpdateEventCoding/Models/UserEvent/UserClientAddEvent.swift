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

/// An event where a new self user client was added.

struct UserClientAddEvent: Equatable, Codable, Sendable {

    /// The new user client.

    let client: SelfUserClient

    /// Create a new `UserClientAddEvent`.
    ///
    /// - Parameter client: The new user client.

    init(client: SelfUserClient) {
        self.client = client
    }

}


struct SelfUserClient: Equatable, Identifiable, Codable, Sendable {

    /// The unique id of the client.

    let id: String

    /// The type of user client.

    let type: UserClientType

    /// The date when the client was activated.

    let activationDate: Date

    /// A label describing the client.

    let label: String?

    /// A description of the client device model.

    let model: String?

    /// The device class of the client.

    let deviceClass: DeviceClass?

    /// When the client was last active.

    let lastActiveDate: Date?

    /// The mls keys for the client.

    let mlsPublicKeys: MLSPublicKeys?

    /// The device cookie.

    let cookie: String?

    /// The capabilities of the client.

    let capabilities: [UserClientCapability]

}


enum DeviceClass: String, Codable, Sendable {

    /// The client is a phone.

    case phone

    /// The client is a tablet.

    case tablet

    /// The client is a desktop computer.

    case desktop

    /// The client is a legalhold device.

    case legalhold

}


struct MLSPublicKeys: Equatable, Codable, Sendable {

    /// The ed25519 signature key.

    let ed25519: String?

    /// The ed448 signature key.

    let ed448: String?

    /// The p256 signature key.

    let p256: String?

    /// The p384 signature key.

    let p384: String?

    /// The p512 signature key.

    let p512: String?

    enum CodingKeys: String, CodingKey {

        case ed25519
        case ed448
        case p256 = "ecdsa_secp256r1_sha256"
        case p384 = "ecdsa_secp384r1_sha384"
        case p512 = "ecdsa_secp521r1_sha512"

    }

}

enum UserClientCapability: String, Codable, Sendable {

    /// The client consents to being subject legalhold
    /// (directly or indirectly).

    case legalholdConsent = "legalhold-implicit-consent"

    /// The client is able to use new incremental sync from server using websocket acknowledgement (async notifications)

    case consumableNotifications = "consumable-notifications"

}

enum UserClientType: String, Codable, Sendable {

    /// A client intended to be used for long periods of time,
    /// such as a mobile device or web application.

    case permanent

    /// A client intended to be used for a short period of time,
    /// such as a web application when the user chooses not to be
    /// remembered.

    case temporary

    /// A special type of client which is used to store a copy of
    /// all messages you send or receive.

    case legalhold

}
