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

/// Delegate that is invoked by `DayScheduleView` to perform actions, typically
/// as the result of user interaction with the appointments or the schedule.
///
/// - since: 1.0
@objc public protocol DayScheduleViewDelegate: NSObjectProtocol {
  /// Notifies the delegate that an appointment was tapped in the day schedule
  /// view.
  ///
  /// - Parameters:
  ///   - dayScheduleView: The `DayScheduleView` view that the appointment was
  ///     tapped in.
  ///   - appointment: The appointment that was tapped.
  ///   - location: The point where the user tapped the appointment, relative
  ///     to the `DayScheduleView` view.
  @objc optional func dayScheduleView(
    _ dayScheduleView: DayScheduleView,
    appointmentTapped appointment: DayScheduleViewAppointment,
    atLocation location: CGPoint
  )

  /// Notifies the delegate that an appointment was long pressed by the user.
  ///
  /// - Parameters:
  ///   - dayScheduleView: The `DayScheduleView` view that the appointment was
  ///     pressed in.
  ///   - appointment: The appointment that was long pressed.
  ///   - location: The point where the user long pressed the appointment,
  ///     relative to the `DayScheduleView` view.
  @objc optional func dayScheduleView(
    _ dayScheduleView: DayScheduleView,
    appointmentLongPressed appointment: DayScheduleViewAppointment,
    atLocation location: CGPoint
  )

  /// Notifies the delegate that the user tapped an open time period.
  ///
  /// - Parameters:
  ///   - dayScheduleView: The `DayScheduleView` view that the time period was
  ///     tapped in.
  ///   - timePeriod: The 30-minute time period that was tapped. `timePeriod`
  ///     is a decimal value. For example, `13.0` is equal to 1pm and `13.5`
  ///     is equal to 1:30pm.
  ///   - location: The point where the user tapped the time period, relative
  ///     to the `DayScheduleView` view.
  @objc optional func dayScheduleView(
    _ dayScheduleView: DayScheduleView,
    timePeriodTapped timePeriod: Float,
    atLocation location: CGPoint
  )

  /// Notifies the delegate that the user long pressed by the user.
  ///
  /// - Parameters:
  ///   - dayScheduleView: The `DayScheduleView` view that the time period was
  ///     long pressed in.
  ///   - timePeriod: The 30-minute time period that was long pressed.
  ///     `timePeriod` is a decimal value. For example, `13.0` is equal to 1pm
  ///     and `13.5` is equal to 1:30pm.
  ///   - location: The point where the user long pressed the time period,
  ///     relative to the `DayScheduleView` view.
  @objc optional func dayScheduleView(
    _ dayScheduleView: DayScheduleView,
    timePeriodLongPressed timePeriod: Float,
    atLocation location: CGPoint
  )
}
