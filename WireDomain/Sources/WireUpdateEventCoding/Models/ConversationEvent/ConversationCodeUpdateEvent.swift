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

/// An event where the conversation's guest link code was updated.

struct ConversationCodeUpdateEvent: Equatable, Codable, Sendable {

    /// The id of the conversation.

    let conversationID: QualifiedID

    /// The id of the user who updated the code.

    let senderID: QualifiedID

    /// The uri to the join the conversation.

    let uri: String?

    /// The conversation's access key.

    let key: String

    /// The conversation's access code.

    let code: String

    /// Whether a password is required to accss the conversation.

    let isPasswordProtected: Bool

}
