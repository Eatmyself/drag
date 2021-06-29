//
//  ContentView.swift
//  hw-gesture
//
//  Created by falcon on 2021/4/10.
//

import SwiftUI

struct demo: View {
  
  @State var progress = 1.0;
 // @State var t: xTimer
  
  @State var data = ["A", "B", "C", "D"]
  @State var offsets: Array<CGSize> = [CGSize.zero, CGSize.zero, CGSize.zero, CGSize.zero]
  @State var lastOffsets: Array<CGSize> = [CGSize.zero, CGSize.zero, CGSize.zero, CGSize.zero]
  
  @State var dropZones: Array<CGRect> = [CGRect.zero]
  
  @State var pipGeometries: Array<CGRect> =  [CGRect.zero, CGRect.zero, CGRect.zero, CGRect.zero]
  
  @State var currentIndex: Int = 0
  
  
  func dropHandler(_ index: Int){
    let pipObjectOffset = offsets[index]
    
    let geometry = pipGeometries[index]
    
    let pipGeometry = CGRect(
      x: geometry.minX + pipObjectOffset.width - geometry.width,
      y:  geometry.minY + pipObjectOffset.height - geometry.height,
      width: geometry.width,
      height: geometry.height
    )
    print("Generated \(pipGeometry.width)x\(pipGeometry.height) pip geomerty x -> \(pipGeometries[index].width) - \(pipObjectOffset.width) | y -> \(pipGeometries[index].height) - \(pipObjectOffset.height) ")
    for dropZone in dropZones {
      print("Is \(pipGeometry) (Init \(pipGeometries[index]), offset \(pipObjectOffset)) in \(dropZone)")
      if pipGeometry.intersects(dropZone) {
        print("INTERSECTS")
        offsets[index] = CGSize(
          width: dropZone.midX - geometry.midX,
          height: dropZone.midY - geometry.midY
        )
        lastOffsets[index] = offsets[index]
      }
    }
    print("-----------")
  }
  
  var body: some View {
    VStack{
      //TimerView(progress: $progress)
      Spacer()
      VStack{
        Spacer()
        Color
          .orange
          .frame(width: 50, height: 50, alignment: .center)
          .overlay(
            GeometryReader(content: { geometry in
              Color.clear
                .onAppear {
                  dropZones[0] = geometry.frame(in: .global)
                }
            })
          )
        HStack{
        ForEach(data, id: \.self){ d in
          Text("\(d)")
            .background(Color.red)
            .offset(offsets[data.firstIndex(of: d)!])
            .overlay(
              GeometryReader(content: { geometry in
                Color.red
                  .opacity(0.2)
                  .onAppear {
                    pipGeometries[data.firstIndex(of: d)!] = geometry.frame(in: .global)
                  }
              })
            )
            .gesture(
              DragGesture()
                .onChanged({ dragValue in
                  let currentIndex = data.firstIndex(of: d)!
                  offsets[currentIndex].width = lastOffsets[currentIndex].width + dragValue.translation.width
                  offsets[currentIndex].height = lastOffsets[currentIndex].height + dragValue.translation.height
                })
                .onEnded({ _ in
                  let currentIndex = data.firstIndex(of: d)!
                  lastOffsets[currentIndex] = offsets[currentIndex]
                  dropHandler(currentIndex)
                })
            )
        }
      }
        Spacer()
//        Button("BTN") {
//          self.t.start()
//        }
        Spacer()
      }//.onAppear(perform: timerInit)
    }
  }
  
//  func timerInit(){
//    self.t = xTimer(time: 10, interval: 0.01, callback: {
//      self.progress -= 0.001
//    })
//  }
}

struct demo_Previews: PreviewProvider {
  static var previews: some View {
    demo()
  }
}
