//
//  play.swift
//  word
//
//  Created by Eatmyself on 2021/4/10.
//

import SwiftUI

func start(_ q: question,
           _ offset: inout Array<CGSize>,
           _ newPosition: inout Array<CGSize>,
           _ mid: inout Array<CGRect>,
           _ ans: inout Array<CGRect>,
           _ win: inout Int,
           _ player: inout Array<Int>,
           _ drag: inout Array<Int>,
           _ secondsElapsed: inout CGFloat) {
  offset =  [CGSize](repeating: .zero, count: q.ans.count+3)
  newPosition = [CGSize](repeating: .zero, count: q.ans.count+3)
  mid = [CGRect](repeating: .zero, count: q.ans.count+3)
  ans = [CGRect](repeating: .zero, count: q.ans.count)
  win = q.ans.count
  player = [Int](repeating: -1, count: q.ans.count)
  drag = [Int](repeating: 1, count: q.ans.count+3)
  secondsElapsed = 300
}

func shuffle(_ q: question,
           _ s: inout Array<String>) {
  let a = ["a²","bc","+","/","-","*","θ","sinθ","cosθ","a","b","c","tanθ","x","y","z","1","90"]
  s = q.ans
  s.append(a[Int.random(in: 0...a.count-1)])
  s.append(a[Int.random(in: 0...a.count-1)])
  s.append(a[Int.random(in: 0...a.count-1)])
  for i in 0...s.count-1{
    let r = Int.random(in: 0...s.count-1)
    let tmp = s[i]
    s[i] = s[r]
    s[r] = tmp
  }
}

struct play: View {
  @State private var timer: Timer?
  func stop() {
    timer?.invalidate()
    timer = nil
  }
  let q = [
    question(number:1,topic:"三角形的面積 =",ans:["底","×","高","÷","2"]),
    question(number:2,topic:"(a+b)(a-b) =",ans:["a²","-","b²"]),
    question(number:3,topic:"圓的面積 =",ans:["π","r²"]),
    question(number:4,topic:"梯形的面積 =",ans:["(","上底","+","下底",")","×","高","÷","2"]),
    question(number:5,topic:"tanθ =",ans:["sinθ","／","cosθ"]),
    question(number:6,topic:"圓錐的體積 =",ans:["1/3","底面","×","積高"]),
    question(number:7,topic:"a³+b³ =",ans:["(","a","+","b",")","(","a²","-","ab","+","b²",")"]),
    question(number:8,topic:"圓的周長 =",ans:["2","π","r"]),
    question(number:9,topic:"(a+b+c)² =",ans:["a²","+","b²","+","c²","+","2ab","+","2bc","+","2ac"]),
    question(number:10,topic:"sec²θ =",ans:["1","+","tan²θ"]),
    question(number:11,topic:"(a+b)(c+d) =",ans:["ac","+","ad","+","bc","+","bd"]),
    question(number:12,topic:"cotθ ＝",ans:["cosθ","／","sinθ"]),

  ]
  @State private var secondsElapsed: CGFloat = 300
  @State private var offset:Array<CGSize> =  [CGSize](repeating: .zero, count: 30)
  @State private var newPosition:Array<CGSize> = [CGSize](repeating: .zero, count: 30)
  @State private var mid:Array<CGRect> = [CGRect](repeating: .zero, count: 30)
  @State private var ans:Array<CGRect> = [CGRect](repeating: .zero, count: 30)
  @State private var now:Int = 9
  @State private var win:Int = 3
  @State private var player:Array<Int> = [Int](repeating: -1, count: 30)
  @State private var drag:Array<Int> = [Int](repeating: 1, count: 30)
  @State private var s:Array<String> = [""]
  @State private var showAlert  = false
  @State private var sheetwin  = false
  @State private var page:Int = 0
  var body: some View {
    ZStack{
      Image("back")
        .resizable()
        .scaledToFill()
        .frame(minWidth: 0, maxWidth: .infinity)
        .edgesIgnoringSafeArea(.all)
      if page == 0{
        VStack{
          Button("Start"){
            start(q[now], &offset, &newPosition, &mid, &ans, &win, &player, &drag, &secondsElapsed)
            shuffle(q[now], &s)
            page = 1
            stop()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ timer in
              if win != 0 && secondsElapsed > 0{
                secondsElapsed = secondsElapsed - 1
              }
              if secondsElapsed <= 0{
                stop()
                print(1)
                showAlert  = true
              }
            }
          }
          .padding()
          .frame(width: 140,height: 40)
          .background(Color.white)
          .cornerRadius(40)
        }
      }
      else if page == 1{
        VStack{
          ProgressView(value: secondsElapsed, total: 300)
              .accentColor(Color.green)
              .scaleEffect(x: 1, y: 4, anchor: .center)
          Text("\(q[now].number). \(q[now].topic)")
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(Color.white)
          HStack{
            ForEach(q[now].ans.indices, id:\.self){ (index) in
              VStack{
                Text("hello")
                  .foregroundColor(.blue)
                Color.gray
                  .frame(width: 50, height: 50, alignment: .center)
                  .overlay(
                    GeometryReader(content: { geometry in
                      if player[index] == -2{
                        Color.black
                      }
                      else{
                        Color.clear
                          .onAppear(perform: {
                            print(geometry.frame(in: .global))
                            ans[index] = geometry.frame(in: .global)
                          })
                      }
                    })
                  )
              }
            }
          }
          Color.clear
            .frame(width: 100, height: 100, alignment: .center)
          HStack{
            ForEach(s.indices, id:\.self){ (index) in
              VStack{
                if drag[index] == 0{
                  Text("hello")
                    .foregroundColor(.blue)
                  Text("\(s[index])")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .offset(offset[index])
                }
                else{
                  Text("\(s[index])")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .offset(offset[index])
                    .overlay(
                      GeometryReader(content: { geometry in
                        Color.gray
                          .opacity(0.3)
                          .onAppear(perform: {
                            mid[index] = geometry.frame(in: .global)
                          })
                      })
                    )
                    .gesture(
                        DragGesture()
                          .onChanged({ value in
                            offset[index].width = newPosition[index].width + value.translation.width
                            offset[index].height = newPosition[index].height + value.translation.height
                          })
                          .onEnded({ value in
                            newPosition[index] = offset[index]
                            let a = CGRect(
                              x: mid[index].minX + offset[index].width - mid[index].width,
                              y: mid[index].minY + offset[index].height - mid[index].height,
                              width: mid[index].width,
                              height: mid[index].height
                            )
                            for i in (0...q[now].ans.count-1).reversed(){
                              if a.intersects(ans[i].offsetBy(dx: -20, dy: -20)){
                                if player[i] == -2{
                                  offset[index] = CGSize.zero
                                  newPosition[index] = CGSize.zero
                                }
                                else{
                                  offset[index].width = ans[i].midX - mid[index].midX
                                  offset[index].height = ans[i].midY - mid[index].midY
                                  newPosition[index] = offset[index]
                                  player[i] = index
                                  if s[index] == q[now].ans[i]{
                                    player[i] = -2
                                    drag[index] = 0
                                    win = win - 1
                                  }
                                }
                                break
                              }
                            }
                          })
                      )
                }
              }
            }
          }
          if win == 0{
            Button("Next ->"){
              if now < 9{
                now = now + 1
                start(q[now], &offset, &newPosition, &mid, &ans, &win, &player, &drag, &secondsElapsed)
                shuffle(q[now], &s)
                page = -1
                stop()
                Timer.scheduledTimer(withTimeInterval: TimeInterval(0.3), repeats: false) { (_) in
                  secondsElapsed = 300
                  timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.1), repeats: true){ timer in
                    if win != 0 && secondsElapsed > 0{
                      secondsElapsed = secondsElapsed - 1
                    }
                    if secondsElapsed <= 0{
                      stop()
                      print(2)
                      showAlert  = true
                    }
                  }
                    page = 1
                 }
              }
              else{
                //you win
                sheetwin = true
                print(3)
                showAlert = true
                stop()
              }
            }
            .padding()
            .frame(width: 140,height: 40)
            .background(Color.white)
            .cornerRadius(40)
          }
        }
      }
    }
    .sheet(isPresented: $showAlert) {
      word.sheet(win: $sheetwin, page: $page)
    }
  }
}


struct play_Previews: PreviewProvider {
  static var previews: some View {
    play()
    //.previewLayout(.fixed(width: 640, height: 320))
  }
}
