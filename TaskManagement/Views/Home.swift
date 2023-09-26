//
//  Home.swift
//  TaskManagement
//
//  Created by Jacek Kosinski U on 26/09/2023.
//

import SwiftUI

struct Home: View {

    /// Task Manager Properties
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView()
        })
        .vSpacing(.top)
    }

    /// Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text(currentDate.format("MMMM"))
                    .foregroundStyle(.darkBlue)

                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.gray)
            }
            .font(.title.bold())
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(.gray)
        }
        .hSpacing(.leading) // wyrównanie do lewej
        .overlay(alignment: .topTrailing, content: {
          Button(action: {}, label: {
            Image(.picture)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 45, height: 45)
            .clipShape(.circle)
          })
        })
        .padding(15)

        .background(.white)
    }

    /// Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            Text("")
        }
    }

    /// Tasks View
    @ViewBuilder
    func TasksView() -> some View {
        Text("")
    }
}

#Preview {
    ContentView()
}
