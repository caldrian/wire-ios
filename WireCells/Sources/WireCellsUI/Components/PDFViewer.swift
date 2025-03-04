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

import PDFKit
import SwiftUI

struct PDFViewer: UIViewRepresentable {
    let pdfDocument: PDFDocument
    var areScrollingIndicatorsVisible: Bool = true
    var isScrollEnabled: Bool = true
    var isUserInteractionEnabled: Bool = true

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true // Automatically scales the PDF to fit
        pdfView.displaysPageBreaks = false // Removes the extra spacing (page breaks) between pages.
        pdfView.displayBox = .cropBox // Tells PDFView to use the crop box (instead of, say, the media box) which often omits any built-in margins.
        pdfView.displayMode = .singlePageContinuous // Continuous scrolling
        pdfView.displayDirection = .vertical // Vertical scrolling
        pdfView.isUserInteractionEnabled = isUserInteractionEnabled
        pdfView.clipsToBounds = true
        pdfView.layer.masksToBounds = true
        pdfView.isUserInteractionEnabled = isUserInteractionEnabled
        if let scrollView = pdfView.subviews.compactMap({ $0 as? UIScrollView }).first {
            scrollView.showsHorizontalScrollIndicator = areScrollingIndicatorsVisible
            scrollView.showsVerticalScrollIndicator = areScrollingIndicatorsVisible
            scrollView.isScrollEnabled = isScrollEnabled
        }
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
       // Nothing to do here
    }

    func scrollEnabled(_ enabled: Bool) -> PDFViewer {
        var copy = self
        copy.isScrollEnabled = enabled
        return copy
    }

    func scrollIndicatorsVisible(_ visible: Bool) -> PDFViewer {
        var copy = self
        copy.areScrollingIndicatorsVisible = visible
        return copy
    }

    func userInteractionEnabled(_ enabled: Bool) -> PDFViewer {
        var copy = self
        copy.isUserInteractionEnabled = enabled
        return copy
    }
}

#Preview {
    VStack {
        PDFViewer(pdfDocument: PDFDocument(url: Bundle.module.url(forResource: "Screenshot", withExtension: "pdf")!)!)
            .frame(width: 350, height: 500)
    }
    .padding()
    .background(.black)
}
