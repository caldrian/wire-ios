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

/// An event where the access settings of a conversation were updated.

struct ConversationAccessUpdateEvent: Equatable, Codable, Sendable {

    let conversationID: QualifiedID
    let senderID: QualifiedID
    let accessModes: [ConversationAccessMode]
    let accessRoles: [ConversationAccessRole]?
    let legacyAccessRole: ConversationAccessRoleLegacy?

}

enum ConversationAccessMode: String, Equatable, Codable, Sendable {

    case `private`
    case invite
    case link
    case code

}

enum ConversationAccessRole: String, Equatable, Codable, Sendable {

    case teamMember = "team_member"
    case nonTeamMember = "non_team_member"
    case guest
    case service

}

enum ConversationAccessRoleLegacy: String, Equatable, Codable, Sendable {

    case `private`
    case team
    case activated
    case nonActivated = "non_activated"

}

struct QualifiedID: Codable, Hashable, Equatable, Sendable {

    let id: UUID
    let domain: String

}

