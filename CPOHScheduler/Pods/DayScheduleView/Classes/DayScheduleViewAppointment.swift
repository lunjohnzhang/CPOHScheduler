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

/// The `Appointment` protocol defines the shape of an appointment or event that
/// is displayed in the `DayScheduleView` view. The `Appointment` protocol
/// exposes the information that the `DayScheduleView` view needs in order to
/// present the appointment in the schedule.
///
/// - since: 1.0
@objc public protocol DayScheduleViewAppointment {
  /// The color to use when displaying the appointment in the schedule.
  var color: UIColor { get }

  /// The title of the appointment.
  var title: String { get }

  /// An optional location that describes where the appointment is occurring.
  var location: String? { get }

  /// The date and time when the appointment begins.
  var startDate: Date { get }

  /// The date and time when the appointment ends.
  /// 
  /// The end date is exclusive of the time of the appointment. For example,
  /// an end time of 11:00 means that the appoitment ends at 10:59.
  var endDate: Date { get }

  /// `true` is the appointment spans the entire day.
  var isAllDay: Bool { get }
}
