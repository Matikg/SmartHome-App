import SwiftUI

struct SprinklerControlView: View {
    @EnvironmentObject var homeModel: HomeModel
    @Environment(\.colorScheme) var colorScheme
    @State private var scheduleButtonPressed = false
    @State private var showSchedule = false
    
    var body: some View {
        ControlGridCell(image: "sprinkler", label: "Sprinkler") {
            VStack {
                
                // Check if the selected date is in the future
                if showSchedule, homeModel.selectedDate > Date() {
                    Label("Scheduled", systemImage: "calendar")
                        .position(x: 100, y: 5)
                }
                else {
                    Label("Not Scheduled", systemImage: "calendar.badge.checkmark.rtl")
                        .position(x: 100, y: 5)
                }
                
                GeometryReader { geo in
                    DatePicker("Schedule Watering", selection: $homeModel.selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.blue.opacity(0.5)))
                        .scaleEffect(0.9)
                        .frame(width: geo.size.width)
                        .position(x: 100, y: 5)
                }
                
                SetButton(title: "Schedule", isPressed: $scheduleButtonPressed, colorScheme: colorScheme) {
                    homeModel.scheduleWatering()
                    showSchedule = true
                }
                .padding(.bottom, 15)
            }
        }
    }
    
    // Date formatter for displaying the scheduled date
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    SprinklerControlView()
        .frame(width: 200, height: 200)
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}

