

import MapKit

class DJIMapPolygon: MKPolygon {
    var strokeColor: UIColor?
    var fillColor: UIColor?
    var lineWidth: CGFloat = 0.0
    var lineDashPhase: CGFloat = 0.0
    var lineCap: CGLineCap!
    var lineJoin: CGLineJoin!
    var lineDashPattern: [NSNumber]?
}
