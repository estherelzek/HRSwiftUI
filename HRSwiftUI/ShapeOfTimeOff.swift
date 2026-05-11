//
//  ShapeOfTimeOff.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct timeOffShape {
    let name: String
    
}

struct TimeOffIcon: View {
    let type: String

    var body: some View {
        switch type {
        case "Confirmed":
            Circle()
                .fill(Color.green)

        case "Submited":
            // Horizontal lines clipped to circle
            Circle()
                .stroke(Color.orange, lineWidth: 1.5)
                .overlay(
                    VStack(spacing: 2) {
                        ForEach(0..<4, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.orange)
                                .frame(height: 1.5)
                        }
                    }
                    .mask(Circle())
                )

        case "Refused":
            // Circle with a horizontal line through center
            Circle()
                .stroke(Color.red, lineWidth: 1.5)
                .overlay(
                    Rectangle()
                        .fill(Color.red)
                        .frame(height: 1.5)
                )

        default:
            Circle()
                .fill(Color.gray)
        }
    }
}

struct ShapeOfTimeOff: View {
    let timeOffShapes: [timeOffShape] = [
        timeOffShape(name: "Confirmed"),
        timeOffShape(name: "Submited"),
        timeOffShape(name: "Refused")]
    
    var body: some View {
        ScrollView(.horizontal , showsIndicators: false) {
            HStack(alignment: .center, spacing: 12) {
                ForEach(timeOffShapes, id: \.name) { shape in
                    HStack(spacing: 6) {
                        TimeOffIcon(type: shape.name)
                            .frame(width: 20, height: 20)
                        Text(shape.name)
                            .font(.body)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ShapeOfTimeOff()
}
