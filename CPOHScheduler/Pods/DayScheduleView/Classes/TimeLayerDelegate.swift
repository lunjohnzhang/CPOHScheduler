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

final class TimeLayerDelegate: NSObject {
  var metrics: DayScheduleViewMetrics!
  var log: DayScheduleViewLogger = DayScheduleViewNullLogger()
}

extension TimeLayerDelegate: CALayerDelegate {
  func draw(_ layer: CALayer, in ctx: CGContext) {
    let hours = [
      "12 AM",
      "1 AM",
      "2 AM",
      "3 AM",
      "4 AM",
      "5 AM",
      "6 AM",
      "7 AM",
      "8 AM",
      "9 AM",
      "10 AM",
      "11 AM",
      "Noon",
      "1 PM",
      "2 PM",
      "3 PM",
      "4 PM",
      "5 PM",
      "6 PM",
      "7 PM",
      "8 PM",
      "9 PM",
      "10 PM",
      "11 PM"
    ]

    var y: CGFloat = 0.0
    for hour in hours {
      draw(hour: hour, at: y, in: ctx)
      y += metrics.hourHeight
    }

    drawHourLine(hour: "12 AM", at: y, in: ctx)
  }

  private func draw(hour: String, at originY: CGFloat, in ctx: CGContext) {
    drawHourLine(hour: hour, at: originY, in: ctx)
    let halfHourLineFrame = metrics.halfHourLineFrame.offsetBy(dx: 0.0, dy: originY)
    ctx.fill(halfHourLineFrame)
  }

  private func drawHourLine(hour: String, at originY: CGFloat, in ctx: CGContext) {
    UIGraphicsPushContext(ctx)
    let hourFrame = metrics.hourFrame.offsetBy(dx: 0.0, dy: originY)
    NSString(string: hour).draw(in: hourFrame, withAttributes: metrics.hourAttributes)
    UIGraphicsPopContext()

    let hourLineFrame = metrics.hourLineFrame.offsetBy(dx: 0.0, dy: originY)
    ctx.fill(hourLineFrame)
  }
}
