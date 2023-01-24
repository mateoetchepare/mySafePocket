//
//  PieChartView.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import SwiftUI

public struct PieChartView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    private var values: [Double]
    private var names: [String] = []
    private let formatter: (Double) -> String = {value in String(format: "$%.2f", value)}
    
    private var colors: [Color] = []
    
    private var widthFraction: CGFloat = 0
    private var innerRadiusFraction: CGFloat = 0
    
    @State private var activeIndex: Int = -1
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            
            var text: String { // esto es para que si un tipo de gasto representa menos del 0.1% no moleste en el grafico
                if (value * 100 / sum) < 0.1 {
                    return ""
                } else {
                    return String(format: "%.0f%%", value * 100 / sum)
                }
            }
            
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: text, color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    public init(values:[Double], names: [String], formatter: @escaping (Double) -> String, colors: [Color], widthFraction: CGFloat = 0.75, innerRadiusFraction: CGFloat = 0.6) {
        // width fraction es el tamanio total del circulo o sea su escala
        // e innerRadiusFraction es agujero que queres q haya en el medio
        self.values = values
        self.names = names
        
        self.colors = colors
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack{
                    ForEach(0..<self.values.count){ i in // itera cant de tipos de gasto q hay asi calcula cant de rebanadas
                        PieSlice(pieSliceData: self.slices[i])
                            .scaleEffect(self.activeIndex == i ? 1.03 : 1)
                            .animation(Animation.spring())
                    }
                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let radius = 0.5 * widthFraction * geometry.size.width
                                let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                if (dist > radius || dist < radius * innerRadiusFraction) {
                                    self.activeIndex = -1
                                    return
                                }
                                var radians = Double(atan2(diff.x, diff.y))
                                if (radians < 0) {
                                    radians = 2 * Double.pi + radians
                                }
                                
                                for (i, slice) in slices.enumerated() {
                                    if (radians < slice.endAngle.radians) {
                                        self.activeIndex = i
                                        break
                                    }
                                }
                            }
                            .onEnded { value in
                                self.activeIndex = -1
                            }
                    )
                    Circle()
                        .fill(backGroundColor())
                        .frame(width: widthFraction * geometry.size.width * innerRadiusFraction, height: widthFraction * geometry.size.width * innerRadiusFraction)
                    
                    VStack {
                        Text(self.activeIndex == -1 ? "Total" : names[self.activeIndex])
                            .font(.title)
                            //.foregroundColor(Color.gray)
                        Text(self.formatter(self.activeIndex == -1 ? values.reduce(0, +) : values[self.activeIndex]))
                        .font(.title)
                    }
                    
                }
                PieChartRows(colors: self.colors, names: self.names, values: self.values.map { self.formatter($0) }, percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) })
            }
            .background(backGroundColor())
           // .foregroundColor(Color.white)
        }
    }
    
    func backGroundColor() -> Color {
        if colorScheme == .dark {
            return Color.black
        } else {
            return Color.white
        }
    }
    
}

@available(OSX 10.15, *)
struct PieChartRows: View {
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]
    
    var body: some View {
        VStack{
            ForEach(0..<self.values.count){ i in
                HStack {
                    Circle()
                        .fill(self.colors[i])
                        .frame(width: 15, height: 15)
                    Text(self.names[i])
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i])
                        Text(self.percents[i])
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
    }
}

@available(OSX 10.15.0, *)
struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(values: [1300, 500, 300], names: ["Rent", "Transport", "Education"], formatter: {value in String(format: "$%.2f", value)}, colors: [Color.red, Color.green, Color.orange])
    }
}
