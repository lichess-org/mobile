import Foundation

extension Date {
    /// "14:53" — used for "Updated at" timestamps.
    var shortTime: String { formatted(.dateTime.hour().minute()) }

    /// "Mar 19" for the current year, "Mar 19, 2025" for a past/future year.
    var widgetDateFormat: FormatStyle {
        let sameYear = Calendar.current.isDate(self, equalTo: .now, toGranularity: .year)
        return sameYear ? .dateTime.month(.abbreviated).day() : .dateTime.month(.abbreviated).day().year()
    }
}
