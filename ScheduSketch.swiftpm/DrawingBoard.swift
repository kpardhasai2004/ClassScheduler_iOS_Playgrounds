import SwiftUI

struct WhiteboardView: View {
    @State private var drawings: [Drawing] = []
    @State private var currentDrawing: Drawing = Drawing()
    @State private var selectedColor: Color = .red
    
    var body: some View {
        VStack {
            WhiteboardCanvas(drawings: $drawings, currentDrawing: $currentDrawing, selectedColor: $selectedColor)
                .background(Color.gray)
        }
    }
}

struct WhiteboardCanvas: View {
    @Binding var drawings: [Drawing]
    @Binding var currentDrawing: Drawing
    @Binding var selectedColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for drawing in drawings {
                    path.addPath(drawing.path)
                }
            }
            .stroke(selectedColor, lineWidth: 2)
            .background(Color.white)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let touchPoint = value.location
                        if !geometry.frame(in: .global).contains(touchPoint) {
                            return
                        }
                        
                        currentDrawing.points.append(touchPoint)
                    }
                    .onEnded { _ in
                        drawings.append(currentDrawing)
                        currentDrawing = Drawing()
                    }
            )
        }
        HStack {
            ColorPicker("", selection: $selectedColor)
                .padding()
            
            Button(action: undo) {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .padding()
                    .foregroundColor(.black)
            }
            
            Button(action: erase) {
                Image(systemName: "trash.circle.fill")
                    .padding()
                    .foregroundColor(.black)
            }
        }
    }
    
    private func undo() {
        if !drawings.isEmpty {
            drawings.removeLast()
        }
    }
    
    private func erase() {
        if !drawings.isEmpty {
            drawings.removeAll()
        }
    }
}

struct Drawing: Identifiable {
    var id = UUID()
    var points: [CGPoint] = []
    
    var path: Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }
        
        path.move(to: firstPoint)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        return path
    }
}

struct WhiteboardView_Previews: PreviewProvider {
    static var previews: some View {
        WhiteboardView()
    }
}
