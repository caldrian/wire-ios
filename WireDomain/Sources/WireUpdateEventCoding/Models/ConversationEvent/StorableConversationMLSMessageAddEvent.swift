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

struct StorableConversationMLSMessageAddEvent: Equatable, Codable, Sendable {

    private let conversationID: StorableQualifiedID
    private let senderID: StorableQualifiedID
    private let subconversation: String?
    private let message: String
    private let timestamp: Date?
    private let decryptedMessages: [StorableDecryptedMessage]

    init(_ value: WireAPI.ConversationMLSMessageAddEvent) {
        self.conversationID = StorableQualifiedID(value.conversationID)
        self.senderID = StorableQualifiedID(value.senderID)
        self.subconversation = value.subconversation
        self.message = value.message
        self.timestamp = value.timestamp
        self.decryptedMessages = value.decryptedMessages.map(StorableDecryptedMessage.init)
    }

}

private struct StorableDecryptedMessage: Equatable, Codable, Sendable {

    let message: String
    let senderClientID: String?

    init(_ value: WireAPI.ConversationMLSMessageAddEvent.DecryptedMessage) {
        self.message = value.message
        self.senderClientID = value.senderClientID
    }

}
