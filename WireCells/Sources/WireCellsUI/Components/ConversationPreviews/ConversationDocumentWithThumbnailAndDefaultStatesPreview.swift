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

public import SwiftUI
import WireDesign
import WireFoundation

public struct ConversationDocumentWithThumbnailAndDefaultStatesPreview<
    Content,
    ContentView: View,
    ViewModel: ConversationDocumentWithThumbnailPreviewViewModel<Content>
>: View {
    let contentView: (Content) -> ContentView
    let headerIcon: Image
    let headerText: String
    let labelText: String

    @ObservedObject var viewModel: ViewModel

    public init(
        headerIcon: Image,
        headerText: String,
        labelText: String,
        viewModel: ViewModel,
        contentView: @escaping (Content) -> ContentView
    ) {
        self.contentView = contentView
        self.headerIcon = headerIcon
        self.headerText = headerText
        self.labelText = labelText
        self.viewModel = viewModel
    }

    public var body: some View {
        ConversationDocumentWithThumbnailAndDefaultStatesPreview(
            headerIcon: headerIcon,
            headerText: headerText,
            labelText: labelText,
            viewModel: viewModel
        ) { content in
            contentView(content)
        }
    }
}

//#Preview {
//    VStack {
//        ConversationDocumentWithThumbnailAndDefaultStatesPreview_Preview()
//            .frame(width: 350, height: 600)
//    }
//    .padding()
//    .background(.black)
//}
