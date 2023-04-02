//
//  NSDate.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/30.
//

import Foundation


extension Date {
    func relativeTime() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    static func fromLocalDateTime(_ localDateTime: [Int]) -> Date? {
           guard localDateTime.count >= 6 else { return nil }
           let year = localDateTime[0]
           let month = localDateTime[1]
           let day = localDateTime[2]
           let hour = localDateTime[3]
           let minute = localDateTime[4]
           let second = localDateTime[5]
           let nanosecond = localDateTime.count > 6 ? localDateTime[6] : 0
           let timeZone = TimeZone(identifier: TimeZone.current.identifier)
           var components = DateComponents()
           components.year = year
           components.month = month
           components.day = day
           components.hour = hour
           components.minute = minute
           components.second = second
           components.nanosecond = nanosecond
           components.timeZone = timeZone
           return Calendar.current.date(from: components)
       }
}

