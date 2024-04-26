import Foundation

import Combine

class TimetableClass: Identifiable, Hashable, Equatable, Codable {
    static func == (lhs: TimetableClass, rhs: TimetableClass) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(className)
        hasher.combine(tutorName)
        hasher.combine(classStartTime)
        hasher.combine(classEndTime)
    }
    
    let id: UUID
    var className: String
    var tutorName: String
    var classStartTime: Date
    var classEndTime: Date
    
    init(id: UUID, className: String, tutorName: String, classStartTime: Date, classEndTime: Date) {
        self.id = id
        self.className = className
        self.tutorName = tutorName
        self.classStartTime = classStartTime
        self.classEndTime = classEndTime
    }
}

class AllClassesManager: ObservableObject{
    @Published var allClasses: [TimetableClass] = [] {
        didSet {
            saveClasses()
        }
    }
    
    init() {
        loadClasses()
        allClasses = [
            TimetableClass(id: UUID(), className: "Math", tutorName: "Robet Smith", classStartTime: Date().addingTimeInterval(0), classEndTime: Date().addingTimeInterval(3600)),
            TimetableClass(id: UUID(), className: "Biology", tutorName: "John Doe", classStartTime: Date().addingTimeInterval(1 * 24 * 60 * 60), classEndTime: Date().addingTimeInterval(3600)),
            TimetableClass(id: UUID(), className: "History", tutorName: "Jane Smith", classStartTime: Date().addingTimeInterval(2 * 24 * 60 * 60), classEndTime: Date().addingTimeInterval(3600)),
            TimetableClass(id: UUID(), className: "Physics", tutorName: "Alice Johnson", classStartTime: Date().addingTimeInterval(3 * 24 * 60 * 60), classEndTime: Date().addingTimeInterval(3600)),
            TimetableClass(id: UUID(), className: "English", tutorName: "Bob Brown", classStartTime: Date().addingTimeInterval(4 * 24 * 60 * 60), classEndTime: Date().addingTimeInterval(3600)),
            TimetableClass(id: UUID(), className: "Chemistry", tutorName: "Eva Davis", classStartTime: Date().addingTimeInterval(5 * 24 * 60 * 60), classEndTime: Date().addingTimeInterval(3600)),
            TimetableClass(id: UUID(), className: "Hindi", tutorName: "Ram Sharma", classStartTime: Date().addingTimeInterval(6 * 24 * 60 * 60), classEndTime: Date().addingTimeInterval(3600))
        ]
    }
    
    private func saveClasses() {
        do {
            let data = try JSONEncoder().encode(allClasses)
            UserDefaults.standard.set(data, forKey: "allClasses")
        } catch {
            print("Error saving classes: \(error.localizedDescription)")
        }
    }
    
    func deleteClass(_ classToDelete: TimetableClass) {
        if let index = allClasses.firstIndex(where: { $0.id == classToDelete.id }) {
            allClasses.remove(at: index)
        }
    }
    
    private func loadClasses() {
        if let data = UserDefaults.standard.data(forKey: "allClasses") {
            do {
                allClasses = try JSONDecoder().decode([TimetableClass].self, from: data)
            } catch {
                print("Error loading classes: \(error.localizedDescription)")
            }
        }
    }
}
