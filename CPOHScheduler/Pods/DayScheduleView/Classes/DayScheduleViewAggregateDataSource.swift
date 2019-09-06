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

/// `DayScheduleView` data source that loads appointments from multiple data
/// sources and provides all of the appointments to the `DayScheduleView` view.
///
/// - Since: 1.0
open class DayScheduleViewAggregateDataSource: DayScheduleViewDataSource {
  private let dataSources: [DayScheduleViewDataSource]

  public var log: DayScheduleViewLogger = DayScheduleViewNullLogger()

  /// Initializes and returns a data source that aggregates and returns
  /// appointments from all of the specified data sources.
  ///
  /// - Parameter dataSources: An array of `DayScheduleViewDataSource` objects
  ///   to load appointments from.
  public init(dataSources: [DayScheduleViewDataSource]) {
    self.dataSources = dataSources
  }

  /// Loads appointments between the specified start time and end time from
  /// all of the contained data sources.
  ///
  /// - Parameters:
  ///   - dayScheduleView: The `DayScheduleView` view.
  ///   - startDate: The date/time of the beginning of the window for the
  ///     appointments to load.
  ///   - endDate: the date/time of the end of the window for the appointments
  ///     to load.
  /// - Returns: An array of `DayScheduleViewAppointment` objects for the
  ///   appointments that start between the `startDate` and `endDate` times.
  public func dayScheduleView(
    _ dayScheduleView: DayScheduleView,
    appointmentsStarting startDate: Date,
    ending endDate: Date
    ) -> [DayScheduleViewAppointment]? {
    log.debug("Querying appontments between \(startDate) and \(endDate) from all data sources")
    var appointments = [DayScheduleViewAppointment]()
    for dataSource in dataSources {
      let dataSourceAppointments = dataSource.dayScheduleView(
        dayScheduleView,
        appointmentsStarting: startDate,
        ending: endDate)
      if let newAppointments = dataSourceAppointments {
        appointments.append(contentsOf: newAppointments)
      }
    }

    log.debug("Returning \(appointments.count) appointments")
    return appointments
  }
}

