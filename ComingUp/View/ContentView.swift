
import SwiftUI
import Combine
import UIKit

struct ContentView: View {
    
    @State var selection: Int? = nil
    @State private var currentNumber = 0
    
    @ObservedObject var dataProvider = DataProvider.shared
    @State private var alertShowing = false
    @State private var editMode: EditMode = .inactive
    
 
    @State var isActive : Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    

    var body: some View {
        
        NavigationView{
            List {
                ForEach(dataProvider.allTodo, id: \.self) { todo in
                    
                    NavigationLink(destination: ComingUpView(todo: todo, rootIsActive: $isActive)) {
                        TodoListCell(todo: todo)
                    }
                    .isDetailLink(false)
                    
                    
                    
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet{
                        let removeImageTitle = dataProvider.allTodo[index].image
                        removeimage(head: removeImageTitle)
                        
                    }
                    
                    dataProvider.delete(indexSet)
                    
                })
                
            }
            .navigationTitle(Text("Next : " + comingUpTitleCreate()))
            .navigationBarItems(leading: EditButton())
            .navigationBarItems(trailing: NavigationLink(destination: NewComingUpView(), tag: 2, selection: $selection){
                Button(action: {
                    self.selection = 2
                }
                       , label: {
                    Image(systemName: "plus.circle.fill")
                }
                       
                       
                )
                
            })
        }
    }
    
    func removeimage(head: String) {
        
        do {
            let furl = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(head)
                .appendingPathExtension("jpeg")
            try FileManager.default.removeItem(at: furl)
            print("remove success")
        } catch {
            print("could not remove imageFile")
        }
    }
    
    func comingUpTitleCreate() -> String {
        
        
        var sortDateArray: [Date] = []
        var comingUpTitle = ""
        
        if dataProvider.allTodo.count == 0 {
            comingUpTitle = "일정이 없습니다"
        } else {
            
            for i in dataProvider.allTodo {
                if let a = i.date.toDate(){
                    sortDateArray.append(a)
                }
                
                
            }
            
        
            
            var before = sortDateArray.sorted(by: { $0.compare($1) == .orderedAscending })
            let firstDate = dateFormatter.string(from: before[0])
            

            
            for i in dataProvider.allTodo {
                if firstDate == i.date {
                    comingUpTitle = i.title
                }
                
            }
            
        }
        
     
        return comingUpTitle
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataProvider: DataProvider.shared)
    }
}


