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

public import PDFKit
public import SwiftUI
import WireFoundation

public class ConversationPDFWithThumbnailPreviewViewModel: ConversationDocumentWithThumbnailPreviewViewModel {

    @Published public var state: ConversationDocumentWithThumbnailPreviewViewModelState<PDFDocument> = .initial

    private let pdfURL: URL

    init(pdfURL: URL) {
        if let url = Bundle.module.url(forResource: "Screenshot", withExtension: "pdf") {
            print("URL: \(url)")
            self.pdfURL = url
        } else {
            print("URL: \(pdfURL)")
            self.pdfURL = pdfURL
        }
    }

    public func loadContent() {
        self.state = .loading
        guard let pdfDocument = PDFDocument(url: self.pdfURL) else {
            state = .loadingFailed
            return
        }
        state = .loaded(pdfDocument)
    }
}

@MainActor
public func conversationPDFWithThumbnailPreview(
    fileSizeInKilobytes: Int,
    fileTitle: String,
    pdfURL: URL
) -> some View {
    ConversationDocumentWithThumbnailPreview(
        headerIcon: Image("square-placeholder", bundle: .module),
        headerText: "PDF (\(fileSizeInKilobytes) KB)",
        labelText: fileTitle,
        viewModel: ConversationPDFWithThumbnailPreviewViewModel(pdfURL: pdfURL)
    ) { state in
        switch state {
        case .initial:
            ProgressView()
        case .loaded(let pdfDocument):
            PDFViewer(pdfDocument: pdfDocument)
                .scrollEnabled(false)
                .scrollIndicatorsVisible(false)
                .userInteractionEnabled(false)
        case .loading:
            ProgressView()
        case .loadingFailed:
            Text("Loading Failed")
        }
    }
}

@MainActor
package func conversationPDFWithThumbnailPreview_Preview() -> some View {
    conversationPDFWithThumbnailPreview(
        fileSizeInKilobytes: 336,
        fileTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ipsum purus, scelerisque molestie rutrum vitae, faucibus in velit. Sed eget consectetur elit, in tristique metus.",
        pdfURL: Bundle.module.url(forResource: "Screenshot", withExtension: "pdf")!
    )
    .environment(\.wireTextStyleMapping, WireTextStyleMapping())
}

#Preview("ConversationPDFPreview") {
    VStack {
        conversationPDFWithThumbnailPreview_Preview()
            .frame(width: 350, height: 500)
    }
    .padding()
    .background(.black)
}
