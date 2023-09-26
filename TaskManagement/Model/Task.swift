//
//  Task.swift
//  TaskManagement
//
//  Created by Jacek Kosinski U on 26/09/2023.
//

import SwiftUI

struct Task: Identifiable {
    var id: UUID = .init()
    var taskTitle: String
    var creationDate: Date = .init()
    var isCompleted: Bool = false
    var tint: Color
}

var sampleTasks: [Task] = [
    .init(taskTitle: "Record Video", creationDate: .updateHour(-1), isCompleted: true, tint: .taskColor1),
    .init(taskTitle: "Redesign Website", creationDate: .updateHour(9), tint: .taskColor2),
    .init(taskTitle: "Go for a Walk", creationDate: .updateHour(10), tint: .taskColor3),
    .init(taskTitle: "Edit Video", creationDate: .updateHour(0), tint: .taskColor4),
    .init(taskTitle: "Publish Video", creationDate: .updateHour(2), tint: .taskColor1),
    .init(taskTitle: "Tweet about new Video!", creationDate: .updateHour(12), tint: .taskColor5),
    .init(taskTitle: "Przygotuj samochód do wynajmu", creationDate: .updateHour(9), tint: .taskColor1),
    .init(taskTitle: "Umów klienta na odbiór samochodu", creationDate: .updateHour(10), tint: .taskColor2),
    .init(taskTitle: "Przekształć samochód na pojazd zimowy", creationDate: .updateHour(11), tint: .taskColor3),
    .init(taskTitle: "Dokumentacja dla klienta", creationDate: .updateHour(12), tint: .taskColor4),
    .init(taskTitle: "Przygotuj kontrakt wynajmu", creationDate: .updateHour(13), tint: .taskColor1),
    .init(taskTitle: "Odbierz zwrot samochodu", creationDate: .updateHour(14), tint: .taskColor2),
    .init(taskTitle: "Zamów części zamiennych", creationDate: .updateHour(15), tint: .taskColor3),
    .init(taskTitle: "Przeszkolenie pracowników", creationDate: .updateHour(16), tint: .taskColor4),
    .init(taskTitle: "Sprawdź stan techniczny pojazdów", creationDate: .updateHour(17), tint: .taskColor1),
    .init(taskTitle: "Zatankuj samochody", creationDate: .updateHour(18), tint: .taskColor2)

]

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
