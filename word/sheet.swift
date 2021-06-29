//
//  sheet.swift
//  word
//
//  Created by Eatmyself on 2021/4/11.
//

import SwiftUI

struct sheet: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var win:Bool
  @Binding var page:Int
    var body: some View {
      ZStack{
        Image("sheet")
          .resizable()
          .scaledToFill()
          .frame(minWidth: 0, maxWidth: .infinity)
          .edgesIgnoringSafeArea(.all)
        VStack{
          if win{
            Text("基本功還行\n算你過關")
              .font(.title)
              .fontWeight(.semibold)
              .background(Color.white)
          }
          else{
            Text("你國高中真的有畢業嗎？\n是不是暑假都在重修數學？")
              .font(.title)
              .fontWeight(.semibold)
              .background(Color.white)
          }
          Button("Home Page"){
            page = 0
            presentationMode.wrappedValue.dismiss()
          }
          .padding()
          .frame(width: 140,height: 40)
          .background(Color.white)
          .cornerRadius(40)
          .overlay(
                  RoundedRectangle(cornerRadius: 40)
                      .stroke(Color.gray, lineWidth: 2)
                  )
        }
      }
        
    }
}

struct sheet_Previews: PreviewProvider {
    static var previews: some View {
      sheet(win:.constant(false), page: .constant(1))
    }
}
