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

    private let dayInitials: [String: String] = [
        "Monday": "S",
        "Tuesday": "T",
        "Wednesday": "Q",
        "Thursday": "Q",
        "Friday": "S",
        "Saturday": "S",
        "Sunday": "D"
    ]

    private let weekDaysOrder: [String] = [
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Schedule:")
                .font(.subheadline)

            HStack(spacing: 8) {
                ForEach(weekDaysOrder, id: \.self) { day in
                    let isActive = schedule.days.contains(day)
                    Text(dayInitials[day] ?? "")
                        .font(.caption)
                        .frame(width: 28, height: 28)
                        .background(isActive ? Color.accentColor : Color.gray.opacity(0.3))
                        .foregroundColor(isActive ? .white : .gray)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .accessibilityLabel(Text(day))
                }
            }

            Text("Time: \(schedule.time)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
