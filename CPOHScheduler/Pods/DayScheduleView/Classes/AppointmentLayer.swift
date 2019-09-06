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

final class AppointmentLayer: NSObject {
  private let settings: DayScheduleViewMetrics
  let appointment: DayScheduleViewAppointment
  let layer = CALayer()

  var log: DayScheduleViewLogger = DayScheduleViewNullLogger()
  
  init(
    settings: DayScheduleViewMetrics,
    appointment: DayScheduleViewAppointment
    ) {
    self.settings = settings
    self.appointment = appointment

    super.init()

    layer.delegate = self
    layer.backgroundColor = UIColor(displayP3Red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0).cgColor
  }
}

extension AppointmentLayer: CALayerDelegate {
  func draw(_ layer: CALayer, in ctx: CGContext) {
    ctx.saveGState()
    ctx.setFillColor(appointment.color.cgColor)
    ctx.fill(CGRect(x: 0.0, y: 0.0, width: 4.0, height: layer.bounds.height))

    UIGraphicsPushContext(ctx)

    var titleAttributes = settings.titleAttributes
    titleAttributes[.foregroundColor] = appointment.color
    let title = NSString(string: appointment.title)
    let titleSize = title.size(withAttributes: titleAttributes)
    let titleRect =
      CGRect(x: 8.0, y: 4.0, width: titleSize.width, height: titleSize.height)
    title.draw(in: titleRect, withAttributes: titleAttributes)

    if let location = appointment.location {
      var locationAttributes = settings.locationAttributes
      locationAttributes[.foregroundColor] = appointment.color
      let locationString = NSString(string: location)
      let locationSize = locationString.size(withAttributes: locationAttributes)
      let locationRect = CGRect(
        x: 8.0,
        y: 8.0 + titleSize.height,
        width: locationSize.width,
        height: locationSize.height
      )
      locationString.draw(in: locationRect, withAttributes: locationAttributes)
    }

    UIGraphicsPopContext()
    ctx.restoreGState()
  }
}
