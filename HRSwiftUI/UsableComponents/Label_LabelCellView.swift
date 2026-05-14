//
//  Label_LabelCellView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 10/05/2026.
//

import SwiftUI

struct Label_LabelCellView: View {
    let textContentOne: String
    let textContentTwo: String
    
    var body: some View {
        HStack {
            Label(textContentOne, systemImage: "pencil")
                .padding()

            Label(textContentTwo, systemImage: "pencil")
                .padding()
        }
    }
}

#Preview {
    Label_LabelCellView(textContentOne: "Description", textContentTwo: "Category")
}
