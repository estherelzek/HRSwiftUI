//
//  Label_LabelCellView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 10/05/2026.
//

import SwiftUI

struct Label_LabelCellView: View {
    @State private var textContentOne: String?
    @State private var textContentTwo: String?
    
    var body: some View {
        HStack {
            Label("\(textContentOne ?? "Text One")", systemImage: "pencil")
            .padding()
            
            
            Label("\(textContentTwo ?? "Text Two")" , systemImage: "pencil")
            .padding()
        }
    }
}

#Preview {
    Label_LabelCellView()
}
