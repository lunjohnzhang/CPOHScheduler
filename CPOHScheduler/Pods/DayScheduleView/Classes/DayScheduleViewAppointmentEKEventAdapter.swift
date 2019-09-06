// Copyright 2018 Naked Software, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import EventKit

/// Adapter type that presents `EKEvent` objects as `DayScheduleViewAppointment`
/// objects to be displayed in the `DayScheduleView` view.
///
/// - Since: 1.0
public class DayScheduleViewAppointmentEKEventAdapter: DayScheduleViewAppointment {
  public let event: EKEvent

  /// Initializes and returns an adapter for the specified event.
  ///
  /// - Parameter event: The `EKEvent` object that should be presented as an
  ///   appointment.
  public init(event: EKEvent) {
    self.event = event
  }

  public var color: UIColor {
    return UIColor(cgColor: event.calendar.cgColor)
  }

  public var title: String {
    return event.title!
  }

  public var location: String? {
    return event.location
  }

  public var startDate: Date {
    return event.startDate!
  }

  public var endDate: Date {
    return event.endDate!
  }

  public var isAllDay: Bool {
    return event.isAllDay
  }
}
