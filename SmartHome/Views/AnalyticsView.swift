//
//  AnalyticsView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @State private var showingSettings = false
    @EnvironmentObject var homeModel: HomeModel
    
    // Date range selection
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date() // Default to last 7 days
    @State private var endDate: Date = Date()
    
    // Log type selection
    @State private var selectedLogType: String = "All" // Default to showing all logs
    
    // Available log types based on device strings
    private var logTypes: [String] {
        ["All", "thermostat", "fan", "power"]
    }
    
    // Filtered logs based on date range and selected log type
    private var filteredLogs: [Log] {
        homeModel.logs.filter { log in
            let isWithinDateRange = log.time >= startDate && log.time <= endDate
            let matchesLogType = selectedLogType == "All" || log.device == selectedLogType
            return isWithinDateRange && matchesLogType
        }
    }
    
    private var averagedLogs: [(date: Date, averageValue: Double)] {
        let calendar = Calendar.current
        
        let groupedLogs = Dictionary(grouping: filteredLogs, by: { calendar.startOfDay(for: $0.time) })
        
        return groupedLogs.map { (date, logs) in
            let totalValue = logs.reduce(0) { $0 + $1.value }
            let averageValue = totalValue / Double(logs.count)
            return (date: date, averageValue: averageValue)
        }
        .sorted(by: { $0.date < $1.date }) // Sort by date
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Chart {
                    ForEach(averagedLogs, id: \.date) { entry in
                        BarMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Average Value", entry.averageValue)
                        )
                        .foregroundStyle(by: .value("Log Type", selectedLogType))
                    }
                }
                .padding()
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) // Customize as needed
                }
                .frame(height: 200)
                
                // Log type picker
                Picker("Log Type", selection: $selectedLogType) {
                    ForEach(logTypes, id: \.self) { logType in
                        Text(logType.capitalized) // Capitalize for better UI presentation
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Date pickers
                HStack {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(filteredLogs, id: \.time) { log in
                            LogRowView(log: log)
                        }
                    }
                }
                .padding(.top)
            }
            .settingsToolbar(showingSettings: $showingSettings, title: "Analysis")
        }
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}
