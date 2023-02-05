
import SwiftUI
import Introspect


struct ComingUpView: View {
    
    let todo: Todo
    @State var selection: Int? = nil
    @Binding var rootIsActive : Bool

    @Environment(\.presentationMode) var presentationMode
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }

    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                
                Text("\(todo.title)")
                    .padding(10)
                    .frame(height: 40)
                    .font(.system(size: 25))
                    .edgesIgnoringSafeArea(.leading)
                
                Divider().background(.black)
                    .frame(width: UIScreen.main.bounds.size.width - 20)
                
                HStack {
                    
                    VStack{
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 30))

                        Text("\(changeFormatString(before: todo.date))")
                            .padding(10)
                            .frame(height: 40)
                            .edgesIgnoringSafeArea(.leading)
                        
                    }
                    
                    Divider()
                        .frame(height: 120)
                    
                    HStack {
                        Image(uiImage: loadImage(image: todo.image))
                            .resizable()
                            .centerCropped()
                            .frame(width: 120, height: 120)
                            .scaledToFit()
                            .cornerRadius(5)
                            .border(Color.gray, width: 1)
                            .edgesIgnoringSafeArea(.all)
                    }
                    .frame(height: 120)
                    .padding(10)
                    
                    
                }
                .frame(width: UIScreen.main.bounds.size.width - 20, alignment: .center)

                
                Divider().background(.black)
                    .frame(width: UIScreen.main.bounds.size.width - 20)
                

                VStack(alignment: .leading){
                    CustomTextEditor.init(placeholder: "입력하세요", text: .constant(todo.content))
                       
                        .font(.body)
                        .background(.gray)
                        .cornerRadius(1)
                        .introspectTextView{
                            $0.isEditable = false
                        }
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
        .navigationBarItems(trailing:
            HStack{
            
            NavigationLink(destination: FixComingUpView(todo: todo, shouldPopToRootView: $rootIsActive), tag: 3, selection: $selection)
            {
                Image(systemName: "square.and.pencil.circle.fill")
            }
            .isDetailLink(false)})
        
    }
    
    func changeFormatString(before: String) -> String {
        var imsi2 = ""
        if let imsi = before.toDate() {
            imsi2 = dateFormatter.string(from: imsi)
           
        }
        return imsi2
        
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
            
            print("error: \(error)") // todo
        }
        return UIImage()
    }
    
    func removeimage(head: String) {
        
        do {
            let furl = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(head)
                .appendingPathExtension("jpeg")
      
            try FileManager.default.removeItem(at: furl)
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
    
}


struct ComingUpView_Previews: PreviewProvider {
    
    static let previewTodo = Todo(title: "마트가기", date: "2023/03/22", image: "", content: "장보기")
    static var previews: some View {
        ComingUpView(todo: previewTodo, rootIsActive: .constant(true))
    }
}


