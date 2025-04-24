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

/// An event where a new conversation was created.

struct ConversationCreateEvent: Equatable, Codable, Sendable {

    let conversationID: StorableQualifiedID
    let senderID: StorableQualifiedID
    let timestamp: Date
    let conversation: Conversation

}

struct Conversation: Equatable, Codable, Sendable {

    /// The unqualified conversation id.

    var id: UUID?

    /// The qualified conversation id.

    var StorableQualifiedID: StorableQualifiedID?

    /// The owning team id.

    var teamID: UUID?

    /// The conversation's type.

    var type: ConversationType?

    /// The conversation's message protocol.

    var messageProtocol: ConversationMessageProtocol?

    /// The id of the associated mls group.

    var mlsGroupID: String?

    /// The mls ciphersuite used for E2EE communcation.

    var cipherSuite: Stored.MLSCipherSuite?

    /// The current mls group epoch.

    var epoch: UInt?

    /// When the mls epoch changed.

    var epochTimestamp: Date?

    /// The user id of the conversation's creator.

    var creator: UUID?

    /// The conversation's participants.

    var members: Members?

    /// The conversation's name.

    var name: String?

    /// The number of seconds after which messages will self delete.

    var messageTimer: TimeInterval?

    /// The conversation's read receipt setting.

    var readReceiptMode: Int?

    /// How users can join a conversation.

    var access: Set<StorableConversationAccessMode>?

    /// Which users are allowed to be participants.

    var accessRoles: Set<StorableConversationAccessRole>?

    /// LEGACY: Which users are allowed to be participants.
    ///
    /// This can be removed when api v3 is the minimum supported version.

    var legacyAccessRole: StorableConversationAccessRoleLegacy?

    var lastEvent: String?

    var lastEventTime: Date?

    var groupType: ConversationGroupType?

    var addPermission: ChannelPermission?

}


enum ConversationType: Int, Codable, Sendable {

    case group = 0
    case `self` = 1
    case oneOnOne = 2
    case connection = 3

}

enum ConversationGroupType: String, Codable, Sendable {
    case group = "group_conversation"
    case channel
}

enum ConversationMessageProtocol: String, Codable, Sendable {

    case proteus
    case mixed
    case mls

}

extension Conversation {
    struct Member: Equatable, Codable, Sendable {

        let StorableQualifiedID: StorableQualifiedID?
        let id: UUID?
        let qualifiedTarget: StorableQualifiedID?
        let target: UUID?
        let conversationRole: String?
        let service: Service?
        let archived: Bool?
        let archivedReference: Date?
        let hidden: Bool?
        let hiddenReference: String?
        let mutedStatus: Int?
        let mutedReference: Date?

    }
}



struct Service: Equatable, Codable, Sendable {

    let id: UUID
    let provider: UUID

}

extension Conversation {

    struct Members: Equatable, Codable, Sendable {
        public let others: [Member]
        public let selfMember: Member

    }

}
