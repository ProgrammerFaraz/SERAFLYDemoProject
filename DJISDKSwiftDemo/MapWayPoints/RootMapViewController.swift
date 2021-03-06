

import UIKit
import MapKit
import CoreLocation
import DJISDK
import SideMenu
import PopupDialog

class RootMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, DJISDKManagerDelegate, DJIFlightControllerDelegate{
    func appRegisteredWithError(_ error: Error?) {
        if let error = error {
            let registerResult = "Registration Error:\(error.localizedDescription)"
           // ShowMessage("Registration Result", registerResult, nil, "OK")
        } else {
            DJISDKManager.startConnectionToProduct()
        }
    }
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        print("idUpdateDatabaseDownloadProgress")
    }
    func productConnected(_ product: DJIBaseProduct?) {
        if product != nil {
            let flightController = DemoUtility.fetchFlightController()
            if let flightController = flightController {
                flightController.delegate = self
            }
        } else {
           // ShowMessage("Product disconnected", nil, nil, "OK")
        }
    }
    
    // Alert Action Controller
    @IBOutlet private var modeLabel: UILabel!
    @IBOutlet private var gpsLabel: UILabel!
    @IBOutlet private var hsLabel: UILabel!
    @IBOutlet private var vsLabel: UILabel!
    @IBOutlet private var altitudeLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var arrowBtn: UIButton!
    private var droneLocation: CLLocationCoordinate2D?
    // End
    
    // Declaring these methods for Polygons and Polylines.
    var points = [CLLocationCoordinate2D]()
    var annotationsArray = [MKPointAnnotation]()
    var gridPoints = [CLLocationCoordinate2D]()
    var fourPoints = [CLLocationCoordinate2D]()
    var dummySimulatorAnnotation:DummyAircraftAnnotation?
    var dummySimulatorFlyPath = [CLLocationCoordinate2D]()
    var gridAnnotationCount = 0
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var createProjectBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parameterImageView: UIImageView!
    var mapController: DJIMapController?
    var tapGesture: UITapGestureRecognizer?
    var isSecondPathToFly = false
    
    // Use for current locatino detection
    var locationManager: CLLocationManager?
    var userLocation: CLLocationCoordinate2D?
    
    var isEditingPoints = false
    
    func initUI() {
        mapView.mapType = .standard
        modeLabel.text = "N/A"
        gpsLabel.text = "0"
        vsLabel.text = "0.0 M/S"
        hsLabel.text = "0.0 M/S"
        altitudeLabel.text = "0 M"
    }
    func initData() {
        userLocation = kCLLocationCoordinate2DInvalid
        droneLocation = kCLLocationCoordinate2DInvalid

        mapController = DJIMapController()
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(addWaypoints(_:)))
//        mapView?.addGestureRecognizer(tapGesture!)

    }
    func registerApp() {
        //Please enter your App key in the info.plist file to register the app.
        DJISDKManager.registerApp(with: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLocation = kCLLocationCoordinate2DInvalid
        mapController = DJIMapController()
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(addWaypoints(_:)))
//        mapView.addGestureRecognizer(tapGesture!)
       

//        registerApp()
//        initUI()
//        initData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.arrowImage.isHidden = true
        self.arrowBtn.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(sideMenuProjectTapped(_:)), name: .projectTapped, object: nil)
         startUpdateLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        locationManager?.stopUpdatingLocation()
    }
    
    @objc func sideMenuProjectTapped(_ notification: Notification) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    //MARK: MAP TOUCH METHODS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        mapView.removeOverlays(mapView.overlays)
//       // mapView.isUserInteractionEnabled = false
//        if let touch = touches.first {
//           let coordinate = mapView.convert(touch.location(in: mapView),      toCoordinateFrom: mapView)
//           points.append(coordinate)
//
//        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//        let coordinate = mapView.convert(touch.location(in: mapView),       toCoordinateFrom: mapView)
//         points.append(coordinate)
//         let polyline = MKPolyline(coordinates: points, count: points.count)
//            mapView.addOverlay(polyline)
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let polygon = MKPolygon(coordinates: &points, count: points.count)
//        mapView.addOverlay(polygon)
//        points = [] // Reset points
//       // mapView.isUserInteractionEnabled = true
    }
    // MARK: CLLocation Methods
    func startUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            if locationManager == nil {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                locationManager?.distanceFilter = CLLocationDistance(0.1)
                if (locationManager?.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))! {
                    locationManager?.requestAlwaysAuthorization()
                }
                locationManager?.startUpdatingLocation()
            }
        } else {
            let alert = UIAlertController(title: "Location Service is not available", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                print("Printed text")
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Custom Methods
    func addWaypoints(completion: @escaping () -> Void) {
//        guard let point = tapGesture?.location(in: mapView) else { return  }

//        var point = [CGPoint]()
        let padding: CGFloat = 100.0
        let imageMargin: CGFloat = 10.0
        let startOne = (CGPoint(x: (parameterImageView.frame.origin.x) + imageMargin, y: (parameterImageView.frame.origin.y) - padding + imageMargin))
        let startTwo = (CGPoint(x: parameterImageView.frame.origin.x + parameterImageView.frame.size.width - imageMargin, y: parameterImageView.frame.origin.y - padding + imageMargin))
        let endOne = (CGPoint(x: parameterImageView.frame.origin.x + imageMargin, y: parameterImageView.frame.origin.y + parameterImageView.frame.size.height - padding - imageMargin))
        let endTwo = (CGPoint(x: parameterImageView.frame.origin.x + parameterImageView.frame.size.width - imageMargin, y: parameterImageView.frame.origin.y + parameterImageView.frame.size.height - padding - imageMargin))
//        point.append(CGPoint(x: (parameterImageView.frame.origin.x) + imageMargin, y: (parameterImageView.frame.origin.y) - padding + imageMargin))
//        point.append(CGPoint(x: parameterImageView.frame.origin.x + parameterImageView.frame.size.width - imageMargin, y: parameterImageView.frame.origin.y - padding + imageMargin))
//        point.append(CGPoint(x: parameterImageView.frame.origin.x + imageMargin, y: parameterImageView.frame.origin.y + parameterImageView.frame.size.height - padding - imageMargin))
//        point.append(CGPoint(x: parameterImageView.frame.origin.x + parameterImageView.frame.size.width - imageMargin, y: parameterImageView.frame.origin.y + parameterImageView.frame.size.height - padding - imageMargin))

//        if tapGesture?.state == .ended {
        let point = [startOne, endOne, startTwo, endTwo]
//            if isEditingPoints {
                gridAnnotationCount = gridAnnotationCount + 1
                guard let mapController = mapController else { return }
                for point in point {
                    let anotPin = mapController.add(point, with: mapView, ident: gridAnnotationCount)
                    annotationsArray.append(anotPin)
                    gridPoints.append(anotPin.coordinate)
                }
        completion()
//            }
//        }
    }
    
    func fillGrid() {
        dummySimulatorFlyPath.removeAll()
        if fourPoints.count > 3 {
            fillGridPath(firstPoint: fourPoints[0], secondPoint: fourPoints[1], thirdPoint: fourPoints[2], fourthPoint: fourPoints[3])
            isSecondPathToFly = true
            fillGridPath(firstPoint: fourPoints[1], secondPoint: fourPoints[2], thirdPoint: fourPoints[3], fourthPoint: fourPoints[0])
            gridPoints.removeAll()
            annotationsArray.removeAll()
            dummySimulatorAnnotation = nil
            addDroneSimulator()
        }else {
            Snackbar.show(message: Constants.morePointsMessage, duration: .short)
        }
    }
    
    func addDroneSimulator() {
        var anotPin = [MKPointAnnotation]()
        for i in 0..<(mapView.annotations.count - 1) {
            if #available(iOS 13.0, *) {
                anotPin.append(MKPointAnnotation(__coordinate: mapView.annotations[i].coordinate))
            } else {
                // Fallback on earlier versions
            }
            gridPoints.append(anotPin[i].coordinate)
        }
        annotationsArray = anotPin
        guard let userLocation = gridPoints.first else { return }
        if CLLocationCoordinate2DIsValid(userLocation) {
            var region = MKCoordinateRegion()
            region.center = userLocation
//            self.userLocation = userLocation
            //  region.center = droneLocation!
            region.span.latitudeDelta = 0.001
            region.span.longitudeDelta = 0.001
            
            if dummySimulatorAnnotation == nil {
                for simulatorAnnotation in mapView.annotations {
                    if simulatorAnnotation is DummyAircraftAnnotation{
                        mapView.removeAnnotation(simulatorAnnotation)
                    }
                }
                dummySimulatorAnnotation = DummyAircraftAnnotation(coordinate: userLocation)
                mapView.addAnnotation(dummySimulatorAnnotation!)
                mapView?.setRegion(region, animated: true)
                mapView.showsUserLocation = true
            }
        }
    }
    
    //MARK:- Action
    
    @IBAction func createProjectHereTapped(_ sender: UIButton) {
        let projectDialog = AddProjectDialogViewController(nibName: "AddProjectDialogViewController", bundle: nil)
        let popup = PopupDialog(viewController: projectDialog,
                                buttonAlignment: .vertical,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true)
        present(popup, animated: true, completion: nil)
        projectDialog.continueCallBack = { projectName in
            self.addWaypoints() { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.drawGrid()
                }
            }
            self.parameterImageView.isHidden = true
            sender.isHidden = true
            popup.dismiss(animated: true, completion: nil)
            self.arrowImage.isHidden = false
            self.arrowBtn.isHidden = false
            let vc = NewTemplateViewController.initFromStoryboard(name: Storyboards.Home)
            self.presentDetail(vc)
        }
    }
    
    @IBAction func currentLocationTapped(_ sender: UIButton) {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 100, longitudinalMeters: 100)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        self.locationManager = locationManager
        
        DispatchQueue.main.async {
            self.locationManager?.startUpdatingLocation()
        }
        
        //        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
    
    @IBAction func changeMapType(_ sender: UIButton) {
        mapView.mapType = mapView.mapType == .standard ? .satellite : .standard
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
        Utilities.setupSideMenu(fromMap: true, viewController: self)
    }
    
    //MARK: - Reset Action
    @IBAction func editBtnAction(_ sender: UIButton) {
//        if isEditingPoints {
        mapController!.cleanAllPoints(with: mapView)
        dummySimulatorFlyPath.removeAll()
        mapView.removeOverlays(mapView.overlays)
        self.parameterImageView.isHidden = false
        self.createProjectBtn.isHidden = false
        self.arrowImage.isHidden = true
        self.arrowBtn.isHidden = true
        fourPoints.removeAll()
        gridPoints.removeAll()
        dummySimulatorAnnotation = nil
        //            editBtn.setTitle("Edit", for: .normal)
        mapView.removeAnnotations(mapView.annotations)
        //            mapView.isUserInteractionEnabled = false
            
            
//           }
//        else {
//               editBtn.setTitle("Reset", for: .normal)
////            mapView.isUserInteractionEnabled = true
//             mapView.removeOverlays(mapView.overlays)
//            gridPoints = [CLLocationCoordinate2D]()
//           }

//        isEditingPoints.toggle()
        
    }
    
    //MARK:- Action
    
    @IBAction func showHideSidePanel(_ sender: UIButton) {
        let vc = NewTemplateViewController.initFromStoryboard(name: Storyboards.Home)
        self.presentDetail(vc)
    }
    
    @IBAction func focusMapAction(_ sender: UIButton) {
        
    }
    
    @IBAction func showGidBtnClicked(_ sender: UIButton) {
//        drawGrid()
    }
    
    @IBAction func fillGridBtnClicked(_ sender: UIButton) {
//        fillGrid()
    }
    
    @IBAction func testFlightBtnClicked(_ sender: UIButton) {
        var heads = 0.0
        var previousLoc = userLocation
        var newLocation = dummySimulatorFlyPath[0]
         let animateSimulatorGroup = DispatchGroup()
        animateSimulatorGroup.enter()
        let semaphore = DispatchSemaphore(value: 0)
        let flyQueue = DispatchQueue(label: "flyQueue", qos: .default)
        flyQueue.async {
            for point1 in self.dummySimulatorFlyPath{
                newLocation = point1
                heads = self.getAngleBetweenTwoPoints1(pt1: previousLoc!, pt2: newLocation)
                self.dummySimulatorAnnotation?.animateAircraft(updatedCordinate: point1, head: heads, completionhandler: { (success) in
                    semaphore.signal()
                })
                semaphore.wait()
                previousLoc = point1
            }
            animateSimulatorGroup.leave()
            DispatchQueue.main.async {
                self.showStatisticsDialog()
            }
        
        }
    }
    
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func getAngleBetweenTwoPoints1(pt1 : CLLocationCoordinate2D, pt2 : CLLocationCoordinate2D) -> Double {
        let point1 = CLLocation(latitude: pt1.latitude, longitude: pt1.longitude)
        let point2 = CLLocation(latitude: pt2.latitude, longitude: pt2.longitude)

        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return fmod(radiansToDegrees(radians: radiansBearing), 360.0) + 90.0
    }
    
    func drawGrid(){
        if self.parameterImageView.isHidden {
//            if fourPoints.count == 0 {
                mapView.removeOverlays(mapView.overlays)
                var pt = [CLLocationCoordinate2D]()
                let annotations = mapView.annotations
                //var selectedAnnotations = mapView.selectedAnnotations
//                for x in 0..<annotations.count - 1 {
                    for ant in annotations{
                        if let pin = ant as? GridAnnotation {
//                            if pin.identifier == x{
                                pt.append(pin.coordinate)
//                            }
                        }
                    }
//                }
                fourPoints = pt
                fourPoints = sortConvex(input: fourPoints)
                let hull = sortConvex(input: pt)
                let polygon = MKPolygon(coordinates: hull, count: hull.count)
                mapView.addOverlay(polygon)
                fillGrid()
//            }
        } else {
            Snackbar.show(message: "Create Project First", duration: .middle)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let coordinate = location?.coordinate {
            userLocation = coordinate
        }
    }
    
    // MARK: MKMapViewDelegate Method

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinView = DJIGridAnnotationView(annotation: annotation, reuseIdentifier: "Grid_Annotation")
            //pinView.pinTintColor = .purple
            pinView.image = UIImage(named:"add.png")
            pinView.contentMode = .scaleAspectFit
            pinView.canShowCallout = false
            pinView.isDraggable = true
           // pinView.animatesDrop = true
            return pinView
        } else if annotation is DJIAircraftAnnotation {
            let annoView = DJIAircraftAnnotationView(annotation: annotation, reuseIdentifier: "Aircraft_Annotation")
            (annotation as? DJIAircraftAnnotation)?.annotationView = annoView
            return annoView
        } else if annotation is DummyAircraftAnnotation {
            let annoView = DummyAircraftAnnotationView(annotation: annotation, reuseIdentifier: "DummyAircraft_Annotation")
            (annotation as? DummyAircraftAnnotation)?.annotationView = annoView
            return annoView
        }
//        else if annotation is GridAnnotation{
//            let gridpointView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Grid_Annotation")
//            gridpointView.image = UIImage(named: "plus.png")
//            gridpointView.isDraggable = true
//            gridpointView.canShowCallout = true
//            return gridpointView
//
//        }

        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.setDragState(.dragging, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .starting:
            print("Point Dragging Started")
            view.dragState = .dragging
            drawGrid()
//            drawGrid()
        case .dragging:
            print("Point Dragging is dragging")
            drawGrid()
//            drawGrid()
        case .canceling, .ending:
            view.dragState = .none
            drawGrid()
            print("Point Dragging Canceled")
//            drawGrid()
        default:
            print("Point Dragging Default case executed")
        }
    }
    
    
    
    
    // Apply this Method for Polygons and PolyLines on Map.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .green
            polylineRenderer.lineWidth = 1
            return polylineRenderer
        } else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = UIColor.lightGray.withAlphaComponent(0.75)
            return polygonView
        }
        return MKPolylineRenderer(overlay: overlay)
    }
    
    func getCordinatesBetweenPoints(startPoint: CLLocationCoordinate2D , endPoint: CLLocationCoordinate2D)->[CLLocationCoordinate2D] {
        let yourTotalCoordinates = Double(5) //1 number of coordinates, change it as per your uses
        let latitudeDiff = startPoint.latitude - endPoint.latitude //2
        let longitudeDiff = startPoint.longitude - endPoint.longitude //3
        let latMultiplier = latitudeDiff / (yourTotalCoordinates + 1) //4
        let longMultiplier = longitudeDiff / (yourTotalCoordinates + 1) //5

        var array = [CLLocationCoordinate2D]()
        array.append(startPoint)//6
        for index in 1...Int(yourTotalCoordinates) { //7
            
            let lat  = startPoint.latitude - (latMultiplier * Double(index)) //8
            let long = startPoint.longitude - (longMultiplier * Double(index)) //9
            let point = CLLocationCoordinate2D(latitude: lat, longitude: long) //10
            array.append(point) //11
        }
        array.append(endPoint)
        print("all your coordinates: \(array)")
        return array
    }
    
    func fillGridPath(firstPoint: CLLocationCoordinate2D , secondPoint: CLLocationCoordinate2D , thirdPoint: CLLocationCoordinate2D , fourthPoint: CLLocationCoordinate2D){
        var top = true
        var gridFillarray = [CLLocationCoordinate2D]()
        let topLinePoints = getCordinatesBetweenPoints(startPoint: firstPoint, endPoint: secondPoint)
        let bottomLinePoints = getCordinatesBetweenPoints(startPoint: fourthPoint, endPoint: thirdPoint)
        for i in 0..<topLinePoints.count{
            if top{
                gridFillarray.append(topLinePoints[i])
                gridFillarray.append(bottomLinePoints[i])
                top = false
            }
            else{
                gridFillarray.append(bottomLinePoints[i])
                gridFillarray.append(topLinePoints[i])
                top = true
            }
        }
        if isSecondPathToFly {
            self.dummySimulatorFlyPath.append(contentsOf: gridFillarray.reversed())
            isSecondPathToFly = false
        }else {
            self.dummySimulatorFlyPath.append(contentsOf: gridFillarray)
        }
        let polyline = MKPolyline(coordinates: gridFillarray, count: gridFillarray.count)
        mapView.addOverlay(polyline)
        
    }
    func showStatisticsDialog(){
        let messageStatistics = "No of Images: 20\nDistance: 2Km\nSpeed: 1km/h\nHeight: 40feets\nAltitude: 20"
        let alertController = UIAlertController(title: "Flight Statistics", message: messageStatistics, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            print("Ok clicked")
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:- Sorted the convex and fixed the grid issue
    func sortConvex(input: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {

        // X = longitude
        // Y = latitude

        // 2D cross product of OA and OB vectors, i.e. z-component of their 3D cross product.
        // Returns a positive value, if OAB makes a counter-clockwise turn,
        // negative for clockwise turn, and zero if the points are collinear.
        func cross(P: CLLocationCoordinate2D, _ A: CLLocationCoordinate2D, _ B: CLLocationCoordinate2D) -> Double {
            let part1 = (A.longitude - P.longitude) * (B.latitude - P.latitude)
            let part2 = (A.latitude - P.latitude) * (B.longitude - P.longitude)
            return part1 - part2;
        }

        // Sort points lexicographically
        let input2 = input
        let points = input2.sorted { (first, second) -> Bool in
            first.longitude == second.longitude ? first.latitude < second.latitude : first.longitude < second.longitude
        }
//        var points = gridPoints.sort {
//            $0.longitude == $1.longitude ? $0.latitude < $1.latitude : $0.longitude < $1.longitude
//        }

        // Build the lower hull
        var lower: [CLLocationCoordinate2D] = []
        for p in points {
            while lower.count >= 2 && cross(P: lower[lower.count-2], lower[lower.count-1], p) <= 0 {
                lower.removeLast()
            }
            lower.append(p)
        }

        // Build upper hull
        var upper: [CLLocationCoordinate2D] = []
        for p in points.reversed() {
            while upper.count >= 2 && cross(P: upper[upper.count-2], upper[upper.count-1], p) <= 0 {
                upper.removeLast()
            }
            upper.append(p)
        }

        // Last point of upper list is omitted because it is repeated at the
        // beginning of the lower list.
        upper.removeLast()

        // Concatenation of the lower and upper hulls gives the convex hull.
        return (upper + lower)
    }
}

extension RootMapViewController: StoryboardInitializable {}
