import SwiftUI
import UserNotifications
import EventKit

struct TimeTableCardSwiftUIView: View {
    var className: String
    var tutorName: String
    var classStartTime: Date
    var classEndTime: Date
    
    @State private var isShowingReminderPopup = false
    @State private var reminderTime = Date()
    @State private var note: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(className)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    isShowingReminderPopup.toggle()
                }) {
                    Text("Add Reminder")
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $isShowingReminderPopup) {
                    ReminderPopupView(isShowingReminderPopup: $isShowingReminderPopup, reminderTime: $reminderTime, note: $note, className: className, tutorName: tutorName)
                }
            }
            
            Text("by \(tutorName)")
                .font(.subheadline)
                .foregroundColor(.black)
            
            Spacer().frame(height: 10)
            
            Text("Timing")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text("\(formattedTiming(date: classStartTime)) - \(formattedTimingWithoutDay(date: classEndTime))")
                    .foregroundColor(.black)
            }
        }
        .padding([.horizontal, .vertical], 15)
        .background(Color.white)
        .cornerRadius(20)
        
    }
    
    private func formattedTiming(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, h:mm a"
        return formatter.string(from: date)
    }
    
    private func formattedTimingWithoutDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct TimeTableCardSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableCardSwiftUIView(
            className: "Math",
            tutorName: "John Doe",
            classStartTime: Date(),
            classEndTime: Date().addingTimeInterval(3600)
        )
    }
}

struct ReminderPopupView: View {
    @Binding var isShowingReminderPopup: Bool
    @Binding var reminderTime: Date
    @Binding var note: String
    var className: String
    var tutorName: String
    
    let notify = NotificationHandler()
    @State var selectedDate = Date()
    
    var body: some View {
        VStack {
            
            Text("Add Reminder")
                .font(.title)
                .fontDesign(.rounded)
            
            DatePicker("Select Reminder Time", selection: $reminderTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .cornerRadius(20)
                .padding()
            
            TextField("Note", text: $note)
                .padding()
                .background(Color.gray)
                .cornerRadius(8)
                .textFieldStyle(PlainTextFieldStyle())
            
            HStack {
                Button("Cancel") {
                    isShowingReminderPopup.toggle()
                }
                .padding()
                .foregroundColor(.blue)
                
                
                Spacer()
                
                Button("Set Reminder") {
                    notify.sendNotification(
                        date: reminderTime,
                        type: "date",
                        title: "LinkTutor",
                        subtitle: "\(className) with \(tutorName)",
                        body: note
                    )
                    isShowingReminderPopup.toggle()
                }
                .padding()
                .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
