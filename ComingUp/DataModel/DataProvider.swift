
import Foundation

class DataProvider: ObservableObject {
    
    static let shared = DataProvider()
    private let dataSourceURL: URL
    @Published var allTodo = [Todo]()
    
    
    init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let todoPath = documentsPath.appendingPathComponent("todo").appendingPathExtension("json")
        dataSourceURL = todoPath
        
        _allTodo = Published(wrappedValue: getAllTodos())
    }
    
    private func getAllTodos() -> [Todo] {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            let decodedTodos = try! decoder.decode([Todo].self, from: data)
            
            return decodedTodos
        } catch {
            return []
        }
    }
    
    private func saveTodos() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allTodo)
            try data.write(to: dataSourceURL)
        } catch {

        }
    }
    
    func create(todo: Todo) {
        allTodo.insert(todo, at: 0)
        saveTodos()
    }
    
    func changeNote(todo: Todo, index: Int) {
        allTodo[index] = todo
        saveTodos()
    }
    
    func delete(_ offsets: IndexSet) {
        allTodo.remove(atOffsets: offsets)
        
        saveTodos()
    }
    
    func move(source: IndexSet, destination: Int) {
        allTodo.move(fromOffsets: source, toOffset: destination)
        saveTodos()
    }
    
    
}
