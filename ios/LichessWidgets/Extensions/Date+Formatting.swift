import Foundation

extension Date {
    /// "14:53" — used for "Updated at" timestamps.
    var shortTime: String { formatted(.dateTime.hour().minute()) }

    /// "14 avr." / "Apr 14" — abbreviated day+month in the device locale.
    /// Includes the year when the date falls outside the current year.
    var widgetDateFormat: Date.FormatStyle {
        let sameYear = Calendar.current.isDate(self, equalTo: .now, toGranularity: .year)
        let base = Date.FormatStyle(locale: .current).month(.abbreviated).day()
        return sameYear ? base : base.year()
    }
}
