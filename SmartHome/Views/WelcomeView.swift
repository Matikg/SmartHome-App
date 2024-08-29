//
//  WelcomeView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 29/08/2024.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("isFirstlaunch") private var isFirstLaunch: Bool = true
    @State private var tabSelection = 0
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelection,
                    content:  {
                VStack(spacing: 20) {
                    Image("control")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    
                    Text("Easily manage and control all your smart devices from one central hub. ")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .multilineTextAlignment(.center)
                .padding()
                .tag(0)
                
                VStack(spacing: 20) {
                    Image("monitor")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    
                    Text("Get real-time updates and stay informed about what's happening in your home.")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .multilineTextAlignment(.center)
                .padding()
                .tag(1)
                
                VStack(spacing: 20) {
                    Image("analyze")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    Text("Dive into detailed analytics with comprehensive logs and charts.")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .multilineTextAlignment(.center)
                .padding()
                .tag(2)
            })
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            Button(action: {
                if tabSelection == 2 {
                    isFirstLaunch = false
                } else {
                    withAnimation {
                        tabSelection += 1
                    }
                }
            }, label: {
                Text(tabSelection == 2 ? "Get Started" : "Next")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
            .padding(50)
        }
    }
}

#Preview {
    WelcomeView()
}
