//
//  SettingView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
      
        List {
            Section(header: Text("General").font(.title2).fontWeight(.bold).foregroundStyle(.primary)) {
                settingCell(imageName: "building.2", title: "Change Company")
                settingCell(imageName: "network", title: "Language")
                settingCell(imageName: "moon", title: "Dark Mode")
            }

            Section(header: Text("Security").font(.title2).fontWeight(.bold).foregroundStyle(.primary)) {
                settingCell(imageName: "lock.open.fill", title: "Change Protection Method")
            }

            Section(header: Text("Account").font(.title2).fontWeight(.bold).foregroundStyle(.primary)) {
                settingCell(imageName: "arrow.right.square", title: "Logout")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingView()
}

struct settingCell: View {
    let imageName: String
    let title: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.border)
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
    
}
#Preview {
    settingCell(imageName: "person.circle", title: "Profile")
}
