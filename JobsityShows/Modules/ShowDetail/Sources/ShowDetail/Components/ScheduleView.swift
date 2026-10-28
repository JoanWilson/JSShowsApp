//
//  ScheduleView.swift
//  ShowDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import Domain
import SwiftUI

struct ScheduleView: View {
    let schedule: Show.Schedule

    private let calendar: Calendar = .autoupdatingCurrent

    private let weekDaysOrder: [String] = [
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Schedule:", bundle: .module)
                .font(.subheadline)

            HStack(spacing: 8) {
                ForEach(Array(weekDaysOrder.enumerated()), id: \.offset) { index, day in
                    let isActive = schedule.days.contains(day)
                    Text(calendar.veryShortStandaloneWeekdaySymbols[index])
                        .font(.caption)
                        .frame(width: 28, height: 28)
                        .background(isActive ? Color.accentColor : Color.gray.opacity(0.3))
                        .foregroundColor(isActive ? .white : .gray)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .accessibilityLabel(Text(calendar.standaloneWeekdaySymbols[index]))
                }
            }

            Text("Time: \(schedule.time)", bundle: .module)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
