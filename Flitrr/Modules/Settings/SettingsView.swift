//
//  SettingsView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 21.04.2022.
//

import SwiftUI

final class SettingsHostingViewConroller: UIHostingController<SettingsView> {
    override init(rootView: SettingsView) {
        super.init(rootView: rootView)
        self.rootView.dismiss = dismissSelf
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissSelf() {
        dismiss(animated: true)
    }
}

struct NavigationBar: View {
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
            }
            Text("Settings")
                .foregroundColor(.white)
                .font(Font(UIFont(name: "Montserrat-Regular", size: 17) ?? .systemFont(ofSize: 17)))
        }
    }
}

struct SettingsView: View {
    
    var dismiss: (() -> ())?
    
    var body: some View {
        SwiftUI.NavigationView {
            ZStack {
                VStack {
                    Color(uiColor: UIColor.appDark)
                        .frame(height: 80)
                    Spacer()
                }.ignoresSafeArea()
               
            }.background(Color(uiColor: UIColor.appDark))
        }
    }
}
