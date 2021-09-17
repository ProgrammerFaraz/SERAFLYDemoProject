

import UIKit
import DJISDK

class DJIFlyLimitPolygonView:MKPolygonRenderer {
    init(polygon: DJIPolygon?) {
        super.init(polygon: polygon!)
        fillColor = DJIFlyZoneColorProvider.getFlyZoneOverlayColor(withCategory: polygon!.level, isHeightLimit: false, isFill: false)
        strokeColor = DJIFlyZoneColorProvider.getFlyZoneOverlayColor(withCategory: polygon!.level, isHeightLimit: false, isFill: true)
            lineWidth = 1.0
            lineJoin = CGLineJoin.bevel
            lineCap = CGLineCap.butt
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        super.draw(mapRect, zoomScale: zoomScale, in: context)

    }
}
