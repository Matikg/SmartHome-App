//
//  DeviceListView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct DeviceListView: View {
    @EnvironmentObject var homeModel: HomeModel
    @State private var showingSettings = false
    @State private var currentDeviceType: DeviceType?
    @State private var showGrid = false
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                VStack {
                    DeviceTypePicker(currentDeviceType: $currentDeviceType)
                        .onChange(of: currentDeviceType) {
                            withAnimation {
                                scrollProxy.scrollTo(0, anchor: .top)
                            }
                        }
                        .padding()
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(filteredRooms()) { room in
                            Text(room.name)
                                .padding()
                                .font(.headline)
                                .id(0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            
                            // Devices
                            LazyVStack(spacing: 10) {
                                ForEach(filteredDevices(for: room)) { device in
                                    DeviceView(device: device)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                    }
                    .padding(.top, -20)
                }
                .settingsToolbar(showingSettings: $showingSettings, title: "Devices")
            }
        }
    }
    
    // MARK: - Filters
    
    private func filteredRooms() -> [Room] {
        guard let type = currentDeviceType else {
            return homeModel.rooms
        }
        return homeModel.rooms.filter { room in
            room.devices.contains { $0.type == type }
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
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}





