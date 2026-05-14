//
//  SettingView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .bold()
                .navigationTitle("")
                .foregroundStyle(.border)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 6)
            
            List {
                
                Section(header: Text("General").font(.title2).foregroundStyle(.primary)
                    .foregroundStyle(.lightGreen.opacity(0.6))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
               ) {
                    settingCell(imageName: "building.2", title: "Change Company")
                    settingCell(imageName: "network", title: "Language")
                    settingCell(imageName: "moon", title: "Dark Mode")
                }

                Section(header: Text("Security").font(.title2).foregroundStyle(.primary)
                    .foregroundStyle(.lightGreen.opacity(0.6))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)) {
                    settingCell(imageName: "lock.open.fill", title: "Change Protection Method")
                }

                Section(header: Text("Account").font(.title2).foregroundStyle(.primary)
                    .foregroundStyle(.lightGreen.opacity(0.6))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)) {
                    settingCell(imageName: "arrow.right.square", title: "Logout")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("")
        }
        .background(Color(red: 0.94, green: 0.94, blue: 0.98).ignoresSafeArea())
        
        
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
                .foregroundStyle(.border)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
    
}
#Preview {
    settingCell(imageName: "person.circle", title: "Profile")
}
