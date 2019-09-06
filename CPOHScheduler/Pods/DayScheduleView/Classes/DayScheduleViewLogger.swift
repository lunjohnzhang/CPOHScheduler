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

/// `DayScheduleViewLogger` defines the protocol for a logging object that is
/// used to output diagnostic information from the `DayScheduleView` control
/// at runtime. The logging output can be used to monitor how `DayScheduleView`
/// works or to diagnose runtime problems.
///
/// - Since: 1.0
public protocol DayScheduleViewLogger {
  /// Writes a message to the log as an error.
  ///
  /// - Parameter message: The message to write to the log.
  func error(_ message: @autoclosure () -> String)

  /// Writes a message to the log as a warning.
  ///
  /// - Parameter message: The message to write to the log.
  func warning(_ message: @autoclosure () -> String)

  /// Writes a message to the log as an informational message.
  ///
  /// - Parameter message: The message to write to the log.
  func info(_ message: @autoclosure () -> String)

  /// Writes a message to the log as a debug message.
  ///
  /// - Parameter message: The message to write to the log.
  func debug(_ message: @autoclosure () -> String)

  /// Writes a message to the log as a verbose message.
  ///
  /// - Parameter message: The message to write to the log.
  func verbose(_ message: @autoclosure () -> String)
}
