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

/// An event where a connection between the self user and
/// another user was updated.

struct UserConnectionEvent: Equatable, Codable, Sendable {

    /// The name of the other user.

    let userName: String?

    /// The connection to the other user.

    let connection: Connection

    init(
        userName: String?,
        connection: Connection
    ) {
        self.userName = userName
        self.connection = connection
    }

}

struct Connection: Equatable, Codable, Sendable {

    /// Remote identifier of the sender

    let senderID: UUID?

    /// Remote identifier of the receiver

    let receiverID: UUID?

    /// Qualified identifier of the receiver

    let receiverQualifiedID: QualifiedID?

    /// Remote identifier of the conversation

    let conversationID: UUID?

    /// Qualified identifier of the conversation

    let qualifiedConversationID: QualifiedID?

    /// Time when connection was last updated

    let lastUpdate: Date

    /// current status of connection

    let status: ConnectionStatus

}


enum ConnectionStatus: String, Codable, Equatable, Sendable {

    /// The connection is complete and the conversation is in its normal state

    case accepted

    /// The user has been blocked

    case blocked

    /// The other user has sent a connection request to this one

    case pending

    /// The connection has been ignored

    case ignored

    /// This user has sent a connection request to another user

    case sent

    /// The connection has been cancelled

    case cancelled

    /// The connection is missing legal hold consent

    case missingLegalholdConsent = "missing-legalhold-consent"
}
