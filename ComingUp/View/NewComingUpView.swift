//
//  NewComingUpView.swift
//  ComingUp
//
//  Created by 김영석 on 2023/01/07.
//

import SwiftUI
import Combine
import UIKit

struct NewComingUpView: View {
    


    @State var InputTitle = ""
    let textLimit = 10
    
    @State var textEdit = ""
    
    @State var fileURL: URL?
    
    @State var pickerDate = Date()
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    @State private var showingAlert = false
    
    @ObservedObject var dataProvider = DataProvider.shared
    
    @Environment(\.presentationMode) var presentationMode
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
  
    
  
    var body: some View {
        
        NavigationView {
            VStack(spacing: 15) {
                
                HStack {
                    TextField("제목", text: $InputTitle)
                        .onReceive(Just(InputTitle)) { _ in limitText(textLimit) }
                        .padding(10)
                        .frame(height: 40)
                        .font(.system(size: 25))
                        .edgesIgnoringSafeArea(.leading)
                }
            
                
                Divider().background(.black)
                    .frame(width: UIScreen.main.bounds.size.width - 20)
                
                HStack{
                    VStack{
                        Image(systemName: "calendar")
                            .font(.system(size: 30))
                        DatePicker(selection: $pickerDate, in: Date()..., displayedComponents: [.date]) {
                        }
                        .frame(alignment: .center)
                        .labelsHidden()
                        .clipped()
                        
                    }
                    .frame(alignment: .leading)
                    .padding(10)
                  
                    Divider()
                        .frame(height: 120)
                    
                    HStack {
                        Image(uiImage: self.image)
                            .resizable()
                            .centerCropped()
                            .frame(width: 120, height: 120)
                            .scaledToFit()
                            .cornerRadius(5)
                            .border(Color.gray, width: 1)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 10) {
                            Button(action: {
                                self.isShowPhotoLibrary.toggle()
                            }, label: {
                                
                                Image(systemName: "photo.fill")
                                    
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                            })
                            .frame(width: 55, height: 55)
                            
                            Button(action: { // 이미지 리셋
                                self.image = UIImage()
                            }, label: {
                                
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                                    
                            })
                            .frame(width: 55, height: 55)
                         
                            
                        }
                
                    }
                    .frame(height: 120)
                    .padding(10)
                    .sheet(isPresented: $isShowPhotoLibrary) {
                        ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
                    }
                }
                .frame(width: UIScreen.main.bounds.size.width - 20, alignment: .center)
  
                Divider().background(.black)
                    .frame(width: UIScreen.main.bounds.size.width - 20)
                            
                VStack(alignment: .leading){
                    CustomTextEditor.init(placeholder: "입력하세요", text: $textEdit)
                        
                        .font(.body)
                        .background(.gray)
                        .cornerRadius(1)
                    Spacer()
                }
                .padding()
                
            }
            .padding()
            
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: goBack) {
            HStack {
                Image(systemName: "chevron.backward").fontWeight(.bold)
                Text("Back")
            }
        })
        .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                 
                    let whitespace = InputTitle.replacingOccurrences(of: " ", with: "")
                    if whitespace == "" {
                        showingAlert = true
                      
                    } else {
                        
                        let title = InputTitle
                        let content = textEdit
                        let onlyDate = dateFormatter.string(from: pickerDate)
                        let imageHead = "\(InputTitle)_\(onlyDate)"
                        
                        let todo = Todo(title: title, date: onlyDate, image: imageHead, content: content)
                        saveImage(head: imageHead)
                        DataProvider.shared.create(todo: todo)
                
                        presentationMode.wrappedValue.dismiss()
                      
                    }
                  
                }
                       , label: {
                    Image(systemName: "plus.circle.fill")
                    
                }
                       
                       
                )
                .alert("타이틀 없음", isPresented: $showingAlert) {
                    Button("OK") {}
                } message: {
                    Text("타이틀을 입력하세요")
                }
                
            })
        })

    }
    
   
    func saveImage(head: String) {
          do {
              let furl = try FileManager.default
                  .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                  .appendingPathComponent(head)
                  .appendingPathExtension("jpeg")
              fileURL = furl
              
              try image.jpegData(compressionQuality: 1)?.write(to: furl)
              print("저장성공")
             
          } catch {
              print("could not create imageFile")
          }
    }
    
    func limitText(_ upper: Int) {
        if InputTitle.count > upper {
            InputTitle = String(InputTitle.prefix(upper))
        }
    }
    
    func goBack(){
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
}



struct NewComingUpView_Previews: PreviewProvider {
    static var previews: some View {
        NewComingUpView()
    }
}

struct CustomTextEditor: View {
    let placeholder: String
    @Binding var text: String
    let internalPadding: CGFloat = 1
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            TextEditor(text: $text)
                .padding(internalPadding)
            
            if text.isEmpty  {
                Text(placeholder)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                    .padding(internalPadding)
            }
            
            
        
        }
    }
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
    }
}
