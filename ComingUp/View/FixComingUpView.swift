

import SwiftUI
import Combine


struct FixComingUpView: View {

    let todo: Todo
    let textLimit = 10
    
    @State var InputTitle = ""
    @State var InputDate = ""
    @State var textEdit = ""

    @State var pickerDate = Date()
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    @State private var showingAlert = false
    
    @ObservedObject var dataProvider = DataProvider.shared
    
    @Environment(\.presentationMode) var presentationMode

    @Binding var shouldPopToRootView : Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var body: some View {
        
        
        NavigationView {
            VStack(spacing: 15) {
                Spacer()
                
                TextField("제목", text: $InputTitle)
                    .onReceive(Just(InputTitle)) { _ in limitText(textLimit) }
                    .onAppear{
                        self.InputTitle = todo.title
                    }
                    .padding(10)
                    .frame(height: 40)
                    .font(.system(size: 25))
                    .edgesIgnoringSafeArea(.leading)
                
                Divider().background(.black)
                    .frame(width: UIScreen.main.bounds.size.width - 20)
                
                HStack{
                    VStack{
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 30))
                        
                        DatePicker(selection: $pickerDate, in: Date()..., displayedComponents: [.date]) {
                        }
                        
                        .onAppear{
                            if let imsi = todo.date.toDate() {
                                self.pickerDate = imsi
                            }
                        }
                        .frame(alignment: .center)
                        .labelsHidden()
                        .clipped()
                        
                    }
                    
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
                            .onAppear{
                                self.image = loadImage(image: todo.image)
                            }
                        
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
                        .onAppear{
                            self.textEdit = todo.content
                        }
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
                      
                        let beforeImage = todo.image
                        
                        let title = InputTitle
                        let date = InputDate
                        let content = textEdit
                        let onlyDate = dateFormatter.string(from: pickerDate)
                        let imageHead = "\(InputTitle)_\(onlyDate)"
                        let findid = todo.id
                        let share = DataProvider.shared.allTodo.count
                       
                        if beforeImage != imageHead {
                            removeimage(head: beforeImage)
                            
                        }
                
                 
                        let find = findIndex(id: todo.id)
                
                        let todo = Todo(title: title, date: onlyDate, image: imageHead, content: content)
                     
                        DataProvider.shared.changeNote(todo: todo, index: find)
                        
                        saveImage(head: imageHead)
                        
                     
                        self.shouldPopToRootView = false

                    }
                    
                }
                       , label: {
                    Image(systemName: "plus.circle.fill")
                    
                })
                .alert("타이틀 없음", isPresented: $showingAlert) {
                    Button("OK") {}
                } message: {
                    Text("타이틀을 입력하세요")
                }
            })
        })
        
        
        
    }
    
    
    func loadImage(image: String) -> UIImage {
        do {
            let furl = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(image)
                .appendingPathExtension("jpeg")
            
    
            let data = try Data(contentsOf: furl)
            if let img = UIImage(data: data) {
                return img
            }
            
        } catch {
            print("error: \(error)")
        }
        return UIImage()
    }
    
    func saveImage(head: String) {
        do {
            let furl = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(head)
                .appendingPathExtension("jpeg")
         
            
            try image.jpegData(compressionQuality: 1)?.write(to: furl)
            print("저장성공")
        } catch {
            print("could not create imageFile")
        }
    }
    
    func removeimage(head: String) {
        
        do {
            let furl = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(head)
                .appendingPathExtension("jpeg")

            try FileManager.default.removeItem(at: furl)
            print("삭제성공")
        } catch {
            print("could not remove imageFile")
        }
    }
    
 
    
    func findIndex(id : UUID) -> Int {
        
        let count = DataProvider.shared.allTodo.count
        var index: Int = 0
        
        for i in 0..<count {
            
            if id == DataProvider.shared.allTodo[i].id
            {
                index = i
            }
            
        }
        
        
        
        return index
        
    }
    
    func goBack(){
       
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func limitText(_ upper: Int) {
        if InputTitle.count > upper {
            InputTitle = String(InputTitle.prefix(upper))
        }
    }
    
}



struct FixComingUpView_Previews: PreviewProvider {
    
    static let previewTodo = Todo(title: "은행가기", date: "2023-03-22", image: "", content: "계좌 만들기")
    
    static var previews: some View {
        FixComingUpView(todo: previewTodo, shouldPopToRootView: .constant(true))
        
    }
}



extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
