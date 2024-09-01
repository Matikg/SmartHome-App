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
    
    // Determines the unit for the selected log type, but returns an empty string if "All" is selected
    private var selectedUnit: String {
        if selectedLogType == "All" {
            return "" // No unit when "All" is selected
        }
        return filteredLogs.first?.unit ?? ""
    }
    
    // Process logs for displaying in the chart
    private var processedLogs: [(date: Date, value: Double)] {
        let calendar = Calendar.current
        let groupedLogs = Dictionary(grouping: filteredLogs, by: { calendar.startOfDay(for: $0.time) })
        
        return groupedLogs.map { (date, logs) in
            if selectedLogType == "power" {
                // Calculate the difference between the first and last log entry of the day
                if let firstLog = logs.first, let lastLog = logs.last {
                    let energyUsed = lastLog.value - firstLog.value
                    return (date: date, value: energyUsed)
                }
            } else {
                // Calculate average for other log types
                let totalValue = logs.reduce(0) { $0 + $1.value }
                let averageValue = totalValue / Double(logs.count)
                return (date: date, value: averageValue)
            }
            return (date: date, value: 0) // Default return value if something goes wrong
        }
        .sorted(by: { $0.date < $1.date }) // Sort by date
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Chart {
                    ForEach(processedLogs, id: \.date) { entry in
                        BarMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("\(selectedLogType == "power" ? "Energy Used" : "Average Value")\(selectedUnit.isEmpty ? "" : " (\(selectedUnit))")", entry.value)
                        )
                        .foregroundStyle(by: .value("Log Type", selectedLogType))
                        .annotation(position: .top) { // Add annotation to show the value and unit on top of the bar
                            Text("\(entry.value, specifier: "%.2f")\(selectedUnit.isEmpty ? "" : " \(selectedUnit)")")
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
                .chartYAxisLabel {
                    Text("\(selectedLogType == "power" ? "Energy Used" : "Average Value")\(selectedUnit.isEmpty ? "" : " (\(selectedUnit))")")
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) // Customize as needed
                }
                .frame(height: 300)
                
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
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()
                    
                    DatePicker("", selection: $endDate, displayedComponents: .date)
                        .labelsHidden()
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

