import SwiftUI
import Charts

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.blue)
            .cornerRadius(8)
    }
}

struct Navigator: View {
    @ObservedObject var allClassesManager: AllClassesManager
    @State private var isAddClassPopupVisible = false
    @State private var newClassName = ""
    @State private var newTutorName = ""
    @State private var newClassStartTime = Date()
    @State private var newClassEndTime = Date()
    
    let notify = NotificationHandler()
    
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Class Scheduler")
                            .font(.system(size: 36).weight(.bold))
                            .fontDesign(.rounded)
                            .foregroundColor(.white)
                            .padding(.bottom, 1)
                        Spacer()
                        
                        Button(action: {
                            isAddClassPopupVisible.toggle()
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .clipped()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.blue)
                        }
                        .padding()
                        .sheet(isPresented: $isAddClassPopupVisible, content: {
                            ScrollView {
                                VStack {
                                    Text("Add Class")
                                        .font(.title)
                                        .fontDesign(.rounded)
                                    
                                    TextField("Class Name", text: $newClassName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                                    TextField("Tutor Name", text: $newTutorName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                                    DatePicker("Start Time", selection: $newClassStartTime, displayedComponents: [.date, .hourAndMinute])
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .padding()
                                    
                                    DatePicker("End Time", selection: $newClassEndTime, displayedComponents: [.date, .hourAndMinute])
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .padding()
                                    
                                    HStack {
                                        Button("Cancel") {
                                            isAddClassPopupVisible.toggle()
                                        }
                                        .padding()
                                        .foregroundColor(.blue)
                                        .cornerRadius(8)
                                        
                                        Spacer()
                                        
                                        Button("Add Class") {
                                            addClass()
                                            isAddClassPopupVisible.toggle()
                                        }
                                        .padding()
                                        .foregroundColor(.blue)
                                        .cornerRadius(8)
                                    }
                                }
                                .padding()
                            }
                        })
                    }
                    
                    VStack {
                        HStack{
                            HStack {
                                Text("Today")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("\(todayClasses.count)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .padding([.horizontal, .vertical], 15)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 12)
                            
                            Spacer()
                            
                            HStack {
                                Text("Tomorrow")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("\(tomorrowClasses.count)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .padding([.horizontal, .vertical], 15)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 12)
                        }
                        
                        Spacer()
                        
                        HStack{
                            let data = [
                                (name : "Today", classes : todayClasses.count ),
                                (name : "Tomorrow", classes: tomorrowClasses.count),
                                (name : "\(formattedDate(date: Date().addingTimeInterval(2 * 24 * 60 * 60)))", classes: Day3Classes.count),
                                (name : "\(formattedDate(date: Date().addingTimeInterval(3 * 24 * 60 * 60)))", classes: Day4Classes.count),
                                (name : "\(formattedDate(date: Date().addingTimeInterval(4 * 24 * 60 * 60)))", classes: Day5Classes.count),
                                (name : "\(formattedDate(date: Date().addingTimeInterval(5 * 24 * 60 * 60)))", classes: Day6Classes.count),
                                (name : "\(formattedDate(date: Date().addingTimeInterval(6 * 24 * 60 * 60)))", classes: Day7Classes.count),
                            ]
                            
                            Chart(data, id: \.name) { name, classes in
                                SectorMark(
                                    angle: .value("Value", classes),
                                    innerRadius: .ratio(0.618),
                                    outerRadius: .inset(10),
                                    angularInset: 1
                                )
                                .cornerRadius(4)
                                .foregroundStyle(by: .value("My Classes", name))
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd - MM - yyyy"
        return formatter.string(from: date)
    }
    
    private var todayClasses: [TimetableClass] {
        return filterClasses(for: Date())
    }
    
    private var tomorrowClasses: [TimetableClass] {
        return filterClasses(for: Date().addingTimeInterval(24 * 60 * 60))
    }
    
    private var Day3Classes: [TimetableClass] {
        return filterClasses(for: Date().addingTimeInterval(2 * 24 * 60 * 60))
    }
    private var Day4Classes: [TimetableClass] {
        return filterClasses(for: Date().addingTimeInterval(3 * 24 * 60 * 60))
    }
    
    private var Day5Classes: [TimetableClass] {
        return filterClasses(for: Date().addingTimeInterval(4 * 24 * 60 * 60))
    }
    
    private var Day6Classes: [TimetableClass] {
        return filterClasses(for: Date().addingTimeInterval(5 * 24 * 60 * 60))
    }
    
    private var Day7Classes: [TimetableClass] {
        return filterClasses(for: Date().addingTimeInterval(6 * 24 * 60 * 60))
    }
    
    
    private func addClass() {
        let newClass = TimetableClass(
            id: UUID(),
            className: newClassName,
            tutorName: newTutorName,
            classStartTime: newClassStartTime,
            classEndTime: newClassEndTime
        )
        allClassesManager.allClasses.append(newClass)
    }
    
    private func filterClasses(for date: Date) -> [TimetableClass] {
        return allClassesManager.allClasses
            .filter { timetableClass in
                let calendar = Calendar.current
                return calendar.isDate(timetableClass.classStartTime, inSameDayAs: date)
            }
    }
}

struct MyTimetablePageSwiftUIView: View {
    @State private var selectedDate: Date = Date()
    @State private var isShowingFilterViewPopup = false
    @StateObject private var allClassesManager = AllClassesManager()
    var notify = NotificationHandler()
    
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        Navigator(allClassesManager: allClassesManager)
                        
                        HStack {
                            Text("My Classes")
                                .font(.system(size: 36).weight(.bold))
                                .fontDesign(.rounded)
                                .foregroundColor(.white)
                                .padding(.bottom, 1)
                            
                            Spacer()
                            
                            Button(action: {
                                isShowingFilterViewPopup.toggle()
                            }) {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .clipped()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.blue)
                            }
                            .padding()
                            .sheet(isPresented: $isShowingFilterViewPopup, content: {
                                VStack {
                                    
                                    Text("Filter Classes")
                                        .font(.title)
                                        .fontDesign(.rounded)
                                    
                                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .padding()
                                    
                                    HStack {
                                        Button("Clear") {
                                            selectedDate = Date()
                                            isShowingFilterViewPopup.toggle()
                                        }
                                        .buttonStyle(ActionButtonStyle())
                                        
                                        Spacer()
                                        
                                        Button("Apply") {
                                            selectedDate = selectedDate
                                            isShowingFilterViewPopup.toggle()
                                        }
                                        .buttonStyle(ActionButtonStyle())
                                    }
                                }
                                .padding()
                            })
                        }
                        
                        if formattedDate(date: selectedDate) != formattedDate(date: Date()) &&
                            formattedDate(date: selectedDate) != formattedDate(date: Date().addingTimeInterval(24 * 60 * 60)) {
                            
                            HStack {
                                Text("\(formattedDate(date: selectedDate))")
                                    .font(Font.system(size: 14).weight(.semibold))
                                    .foregroundColor(.white)
                                Spacer()
                                Button("Clear") {
                                    selectedDate = Date()
                                    isShowingFilterViewPopup = false
                                }
                                .buttonStyle(ActionButtonStyle())
                            }
                            
                            if filteredClasses.isEmpty {
                                Text("No classes Found!")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding([.horizontal, .vertical], 15)
                                    .background(Color.white)
                                    .cornerRadius(20)
                            } else {
                                ForEach(filteredClasses, id: \.self) { timetableClass in
                                    TimeTableCardSwiftUIView(
                                        className: timetableClass.className,
                                        tutorName: timetableClass.tutorName,
                                        classStartTime: timetableClass.classStartTime,
                                        classEndTime: timetableClass.classEndTime
                                    )
                                }
                            }
                        } 
                        
                        if todayClasses.count != 0 {
                            Text("Today").font(Font.system(size: 14).weight(.semibold)).foregroundColor(.white).padding()
                            
                            ForEach(todayClasses, id: \.self) { timetableClass in
                                TimeTableCardSwiftUIView(
                                    className: timetableClass.className,
                                    tutorName: timetableClass.tutorName ,
                                    classStartTime: timetableClass.classStartTime,
                                    classEndTime: timetableClass.classEndTime
                                )
                            }
                        }
                        
                        if tomorrowClasses.count != 0 {
                            Text("Tomorrow").font(Font.system(size: 14).weight(.semibold)).foregroundColor(.white).padding()
                            
                            ForEach(tomorrowClasses, id: \.self) { timetableClass in
                                TimeTableCardSwiftUIView(
                                    className: timetableClass.className,
                                    tutorName: timetableClass.tutorName ,
                                    classStartTime: timetableClass.classStartTime,
                                    classEndTime: timetableClass.classEndTime
                                )
                            }
                        }
                    }
                    .padding()
                }
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 12)
                .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
                .navigationBarTitle("Timetable", displayMode: .inline)
            }
            .padding()
            VStack(alignment: .leading) {
                Spacer()
                Button("Need Permission?") {
                    notify.askPermission()
                }
                .foregroundColor(.blue)
                .padding()
            }
        }
        .environmentObject(allClassesManager)
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd - MM - yyyy"
        return formatter.string(from: date)
    }
    
    private var todayClasses: [TimetableClass] {
        filterClasses(for: Date())
    }
    
    private var tomorrowClasses: [TimetableClass] {
        filterClasses(for: Date().addingTimeInterval(24 * 60 * 60))
    }
    
    private var filteredClasses: [TimetableClass] {
        filterClasses(for: selectedDate)
    }
    
    private func filterClasses(for date: Date) -> [TimetableClass] {
        return allClassesManager.allClasses
            .filter { timetableClass in
                let calendar = Calendar.current
                return calendar.isDate(timetableClass.classStartTime, inSameDayAs: date)
            }
    }
}

struct MyTimetablePageSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MyTimetablePageSwiftUIView()
    }
}
