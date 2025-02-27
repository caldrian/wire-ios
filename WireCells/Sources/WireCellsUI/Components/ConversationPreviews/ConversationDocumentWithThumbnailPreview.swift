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

public enum ConversationDocumentWithThumbnailPreviewViewModelState<Content> {
    case initial
    case loaded(Content)
    case loading
    case loadingFailed
}

public protocol ConversationDocumentWithThumbnailPreviewViewModel<Content>: ObservableObject {
    associatedtype Content

    var state: ConversationDocumentWithThumbnailPreviewViewModelState<Content> { get }
}

public struct ConversationDocumentWithThumbnailPreview<
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
        GeometryReader { geometry in
            VStack {
                ConversationDocumentPreviewHeader(
                    headerIcon: headerIcon,
                    headerText: headerText,
                    labelText: labelText
                )
                .padding(8)
                Group {
                    switch viewModel.state {
                    case .initial:
                        if #available(iOS 17.0, *) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(ColorTheme.Backgrounds.background.color)
                                .stroke(
                                    BaseColorPalette.Grays.gray40.color,
                                    lineWidth: 1
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(ColorTheme.Backgrounds.background.color)
                        }
                    case let .loaded(content):
                        contentView(content)
                            .frame(height: geometry.size.width / (4 / 3), alignment: .top)
                            .clipped()
                    case .loading:
                        if #available(iOS 17.0, *) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(ColorTheme.Backgrounds.background.color)
                                .stroke(
                                    BaseColorPalette.Grays.gray40.color,
                                    lineWidth: 1
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(ColorTheme.Backgrounds.background.color)
                        }
                    case .loadingFailed:
                        if #available(iOS 17.0, *) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(ColorTheme.Backgrounds.background.color)
                                .stroke(
                                    BaseColorPalette.Grays.gray40.color,
                                    lineWidth: 1
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(ColorTheme.Backgrounds.background.color)
                        }
                    }
                }
                .frame(height: geometry.size.width / (4 / 3))
                .clipped()
            }
            .roundedBorderAndBackground(
                backgroundColor: ColorTheme.Backgrounds.surfaceVariant
                    .color,
                borderColor: ColorTheme.Strokes.outline.color,
                borderWidth: 1,
                cornerRadius: 10,
                padding: 0
            )
            .gesture(LongPressGesture(minimumDuration: 0.5))
        }
    }
}

package class ImageViewModel: ConversationDocumentWithThumbnailPreviewViewModel {
    @Published public var state: ConversationDocumentWithThumbnailPreviewViewModelState<Image> = .loaded(Image(
        "square-placeholder",
        bundle: .module
    ))
}

package struct ConversationDocumentWithThumbnailPreview_Preview: View {
    package var body: some View {
        ConversationDocumentWithThumbnailPreview(
            headerIcon: Image("square-placeholder", bundle: .module),
            headerText: "Document (336 KB)",
            labelText: "Lorem ipsum",
            viewModel: ImageViewModel()
        ) { (content: Image) in
            content
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .environment(\.wireTextStyleMapping, WireTextStyleMapping())
    }
}

#Preview {
    VStack {
        ConversationDocumentWithThumbnailPreview_Preview()
            .frame(width: 350, height: 600)
    }
    .padding()
    .background(.black)
}
