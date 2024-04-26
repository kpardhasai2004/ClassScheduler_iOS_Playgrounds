import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            NavigationView {
                List {
                    NavigationLink(destination: MyTimetablePageSwiftUIView()) {
                        Label("My Timetable", systemImage: "calendar")
                    }
                    
                    NavigationLink(destination: WhiteboardView()) {
                        Label("Whiteboard", systemImage: "pencil")
                    }
                }
                .listStyle(SidebarListStyle())
                Text("Select an option from the sidebar")
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
