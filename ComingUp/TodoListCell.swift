
import SwiftUI

struct TodoListCell: View {
    let todo: Todo
    var body: some View {
    
        HStack {
            
            Image(uiImage: loadImage(image: todo.image))
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .border(Color.gray)
                .clipped()
            
            VStack(alignment: .leading) {
                
                
                Text("\(todo.title)")
                    .font(.headline)
                
                Text("\(todo.date)")
                    .font(.footnote)
              
            }
        }
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
}


struct TodoListCell_Previews: PreviewProvider {
    static var previews: some View {
        TodoListCell(todo: Todo(title: "슈퍼가기", date: "12/26/2022", image: "SwiftUI" ,content: "과일사기"))
    }
}
