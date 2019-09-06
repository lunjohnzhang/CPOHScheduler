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

final class CurrentTimeLayerDelegate: NSObject {
  private let dateFormatter = DateFormatter()

  var metrics: DayScheduleViewMetrics!
  var log: DayScheduleViewLogger = DayScheduleViewNullLogger()

  override init() {
    super.init()
    
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
  }
}

extension CurrentTimeLayerDelegate: CALayerDelegate {
  func draw(_ layer: CALayer, in ctx: CGContext) {
    let now = Date()
    let currentTime = dateFormatter.string(from: now)
    let components = Calendar.current.dateComponents([.minute], from: now)

    ctx.saveGState()

    if components.minute! < 10 || components.minute! > 50 {
      let backgroundRect = CGRect(x: 0.0, y: 0.0, width: metrics.hourSize.width, height: layer.bounds.height)
      ctx.setFillColor(UIColor.white.cgColor)
      ctx.fill(backgroundRect)
    }

    UIGraphicsPushContext(ctx)
    var attributes = metrics.hourAttributes
    attributes[.foregroundColor] = UIColor.red
    let hourY = (layer.bounds.height / 2.0) - (metrics.hourFrame.height / 2.0)
    let hourRect = CGRect(x: metrics.hourFrame.origin.x, y: hourY, width: metrics.hourFrame.width, height: metrics.hourFrame.height)
    NSString(string: currentTime).draw(in: hourRect, withAttributes: attributes)
    UIGraphicsPopContext()

    ctx.setFillColor(UIColor.red.cgColor)
    let rect = CGRect(
      x: metrics.hourSize.width,
      y: layer.bounds.height / 2.0,
      width: layer.bounds.width - metrics.hourSize.width,
      height: 1.0
    )
    ctx.fill(rect)

    ctx.restoreGState()
  }
}
