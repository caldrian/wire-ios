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

/// An event where one of the self user's persisted
/// properties was set.

struct UserPropertiesSetEvent: Equatable, Codable {

    /// The updated user property.

    let property: UserProperty

    init(property: UserProperty) {
        self.property = property
    }

}

enum UserProperty: Equatable, Codable {

    /// Whether the self user has enabled read receipts.

    case areReadReceiptsEnabled(Bool)

    /// Whether the self user has enabled typing indicators.

    case areTypingIndicatorsEnabled(Bool)

    /// The conversation labels setting.

    case conversationLabels([ConversationLabel])

    /// An unknown property.

    case unknown(key: String)

}

struct ConversationLabel: Equatable, Codable, Sendable {

    /// The label's id.

    let id: UUID

    /// The label's name.

    let name: String?

    /// The label's raw type.

    let type: Int16

    /// The conversation ids associated with the label.

    let conversationIDs: [UUID]

}
