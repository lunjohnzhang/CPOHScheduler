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

/// Appointment data source that loads appointments from the user's calendar
/// database using EventKit.
///
/// `EKEventStoreDataSource` can be used as a default data source to display
/// events in the user's calendar database in the day schedule view as
/// appointments.
///
/// - Since: 1.0
open class EKEventStoreDataSource: DayScheduleViewDataSource {
  private let eventStore: EKEventStore
  private let calendars: [EKCalendar]?

  public var log: DayScheduleViewLogger = DayScheduleViewNullLogger()

  /// Initializes and returns a data source object that loads events from the
  /// event store and from specific calendars.
  ///
  /// - Parameters:
  ///   - eventStore: The `EKEventStore` object to use to read events from the
  ///     user's calendar database.
  ///   - calendars: An optional array containing the calendars whose events
  ///     should be shown in the day schedule view. If `nil`, then events from
  ///     all calendars will be loaded.
  public init(eventStore: EKEventStore, calendars: [EKCalendar]? = nil) {
    self.eventStore = eventStore
    self.calendars = calendars
  }

  public func dayScheduleView(
    _ dayScheduleView: DayScheduleView,
    appointmentsStarting startDate: Date,
    ending endDate: Date) -> [DayScheduleViewAppointment]? {
    log.debug("Querying events between \(startDate) and \(endDate) from EKEventStore")
    let predicate = eventStore.predicateForEvents(
      withStart: startDate,
      end: endDate,
      calendars: calendars
    )
    let appointments = eventStore.events(matching: predicate)
      .map { DayScheduleViewAppointmentEKEventAdapter(event: $0) }
    log.debug("Returning \(appointments.count) appointments")
    for appointment in appointments {
      log.verbose("\(appointment.title): \(appointment.isAllDay)")
    }
    
    return appointments
  }
}
