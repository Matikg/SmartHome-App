//
//  DeviceListView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct DeviceListView: View {
    @State private var showingSettings = false
    @EnvironmentObject var homeModel: HomeModel
    @State var currentDeviceType: DeviceType?
    
    var body: some View {
        NavigationView {
            VStack {
                
                DeviceTypePicker(currentDeviceType: $currentDeviceType)
                    .padding()
                
                ScrollView {
                    LazyVStack() {
                        ForEach(homeModel.rooms) { room in
                            Text(room.name)
                            ForEach(filteredDevices(for: room)) { device in
                                DeviceView(device: device)
                                    .animation(.default, value: currentDeviceType)
                            }
                        }
                    }
                    .padding()
                }
            }
            .settingsToolbar(showingSettings: $showingSettings, title: "Devices")
        }
    }
    
    
    private func filteredDevices(for room: Room) -> [Device] {
        guard let type = currentDeviceType else {
            return room.devices
        }
        return room.devices.filter { $0.type == type }
    }
    
}


#Preview {
    DeviceListView()
        .environmentObject(MQTTManager())
        .environmentObject(HomeModel())
}




