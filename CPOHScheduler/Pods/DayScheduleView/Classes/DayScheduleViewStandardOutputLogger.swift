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

/// `DayScheduleViewStandardOutputLogger` is a logger implementation that writes
/// log messages to the device's standard output. The log messages will be
/// visible in the Xcode debugger's console.
///
/// - Since: 1.0
public struct DayScheduleViewStandardOutputLogger: DayScheduleViewLogger {
  /// The logging levels that can be used to control output of the logger.
  public enum LogLevel: Int {
    /// Enables output of error messages.
    case error = 0

    /// Enables output of error and warning messages.
    case warning = 1

    /// Enables output of error, warning, and informational messages.
    case info = 2

    /// Enables output of error, warning, informational, and debug messages.
    case debug = 3

    /// Enables output of all log messages.
    case verbose = 4
  }

  private let logLevel: LogLevel

  /// Initializes and returns a `DayScheduleViewStandardOutputLogger` object.
  ///
  /// - Parameter logLevel: The desired level of output that should be written
  ///   to standard output by the logger.
  public init(logLevel: LogLevel) {
    self.logLevel = logLevel
  }
  
  public func error(_ message: @autoclosure () -> String) {
    print("ERROR: \(message())")
  }

  public func warning(_ message: @autoclosure () -> String) {
    guard logLevel.rawValue >= LogLevel.warning.rawValue else {
      return
    }

    print("WARNING: \(message())")
  }

  public func info(_ message: @autoclosure () -> String) {
    guard logLevel.rawValue >= LogLevel.info.rawValue else {
      return
    }

    print("INFO: \(message())")
  }

  public func debug(_ message: @autoclosure () -> String) {
    guard logLevel.rawValue >= LogLevel.debug.rawValue else {
      return
    }

    print("DEBUG: \(message())")
  }

  public func verbose(_ message: @autoclosure () -> String) {
    guard logLevel.rawValue >= LogLevel.verbose.rawValue else {
      return
    }
    
    print("VERBOSE: \(message())")
  }
}
