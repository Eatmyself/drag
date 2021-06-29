//
//  ContentView.swift
//  word
//
//  Created by Eatmyself on 2021/4/2.
//

import SwiftUI

struct ContentView: View {
    @State private var offset = CGSize.zero
    @State private var newPosition = CGSize.zero
    @State private var blue = CGRect.zero
    @State private var w = CGRect.zero
    @State private var q = 0
    
    var dragGesture: some Gesture {
        DragGesture()
        .onChanged({ value in
            offset.width = newPosition.width + value.translation.width
            offset.height = newPosition.height + value.translation.height
        })
        .onEnded({ value in
            newPosition = offset
            if (w.midY + newPosition.height-blue.midY) < 25 && (w.midY + newPosition.height-blue.midY) > -25 && w.midX + (newPosition.width-blue.midX) < 25 && (w.midX + newPosition.width-blue.midX) > -25{
                q = 1
                offset.width = blue.midX - w.midX
                offset.height = blue.midY - w.midY
                newPosition = offset
            }else{
                q = 0
            }
        })
    }
    
    var body: some View {
        VStack{
            Text("\(q)")
            Color.blue
            .frame(width: 50, height: 50, alignment: .center)
            .overlay(
                GeometryReader(content: { geometry in
                    Color.clear
                        .onAppear(perform: {
                            blue = geometry.frame(in: .global)
                        })
                })
            )
            Text("A")
                .padding()
                .offset(offset)
                .overlay(
                    GeometryReader(content: { geometry in
                        Color.clear
                            .onAppear(perform: {
                                w = geometry.frame(in: .global)
                            })
                    })
                )
                .gesture(dragGesture)
            Text("B")
                .padding()
                .offset(offset)
                .overlay(
                    GeometryReader(content: { geometry in
                        Color.clear
                            .onAppear(perform: {
                                w = geometry.frame(in: .global)
                            })
                    })
                )
                .gesture(dragGesture)
                
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 640, height: 320))
    }
}
