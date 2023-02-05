import Foundation
import SwiftUI

struct Todo: Codable, Hashable, Equatable {
    var id = UUID()
    let title: String
    let date: String
    let image: String
    let content: String

}
