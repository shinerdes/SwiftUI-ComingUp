//
//  FixComingUpView.swift
//  ComingUp
//
//  Created by 김영석 on 2023/01/08.
//

import SwiftUI

struct FixComingUpView: View {
    
    @State var InputTitle = ""
    @State var textEdit = ""
    
    var body: some View {
        
        
        NavigationView {
            VStack(spacing: 15) {
                Spacer()
                
                TextField("유후", text: $InputTitle)
                    .padding()
                    .background(.green)
                    .edgesIgnoringSafeArea(.leading) // 제목
                
                Divider().background(.black)
                    .frame(width: UIScreen.main.bounds.size.width - 20)
                
                TextField("유후", text: $InputTitle)
                    .padding()
                    .background(.green)
                    .edgesIgnoringSafeArea(.leading) // Date
                
                Divider().background(.black)
                    .frame(width: UIScreen.main.bounds.size.width - 20)
                
                Image(systemName: "circle.fill") // 이미지
                    .frame(height: 100)
                
                Divider().background(.black)
                    .frame(width: UIScreen.main.bounds.size.width - 20)
                
                
                TextEditor(text: $textEdit)
                    .scrollContentBackground(.hidden)
                    .background(.gray)
                    .foregroundColor(.green)
                
            }
            .padding()
        }
        .navigationBarTitle("내 프로필")
        .navigationBarItems(trailing:
            NavigationLink(destination:
                Text("설정화면입니다.")
                    .font(.largeTitle)
                    .fontWeight(.black)
            ){
               Image(systemName: "circle.fill")
                .font(.largeTitle)
                .foregroundColor(Color.black)
            }
        )
    }
    
}

struct FixComingUpView_Previews: PreviewProvider {
    static var previews: some View {
        FixComingUpView()
    }
}
