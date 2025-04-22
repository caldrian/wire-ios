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

/// An event where a team was created.

struct TeamCreateEvent: Equatable, Codable, Sendable {

    /// The team id.

    let identifier: UUID

    /// The team name.

    let name: String

    /// The team creator id.

    let creator: UUID

    /// The team icon.

    let icon: String

    /// The team icon key.

    let iconKey: String?

    /// The team splash screen.

    let splashScreen: String?

    init(
        identifier: UUID,
        name: String,
        creator: UUID,
        icon: String,
        iconKey: String?,
        splashScreen: String?
    ) {
        self.identifier = identifier
        self.name = name
        self.creator = creator
        self.icon = icon
        self.iconKey = iconKey
        self.splashScreen = splashScreen
    }

}
