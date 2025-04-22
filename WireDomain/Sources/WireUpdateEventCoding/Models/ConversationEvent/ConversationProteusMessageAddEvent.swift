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

/// An event where a proteus message was received in a conversation.

struct ConversationProteusMessageAddEvent: Equatable, Codable, Sendable {

    /// The id of the conversation.

    let conversationID: QualifiedID

    /// The id of the user who sent the message.

    let senderID: QualifiedID

    /// When the message was sent.

    let timestamp: Date

    /// The base 64 encoded message.

    var message: MessageContent

    /// The base 64 encoded external data.

    var externalData: MessageContent?

    /// The id of the user client who sent the message.

    let messageSenderClientID: String

    /// The id of the user client who should receive the message.

    let messageRecipientClientID: String

}

struct MessageContent: Equatable, Codable, Sendable {

    /// Encrypted message content.

    let encryptedMessage: String

    /// Unencrypted message content.

    var decryptedMessage: String?

}
