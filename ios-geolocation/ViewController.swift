//
//  ViewController.swift
//  ios-geolocation
//
//  Created by KOrnel Boros on 14.12.2021..
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{
  @IBOutlet var swLocation: UISwitch!

  @IBOutlet var lblLocationTrackingEnabledValue: UILabel!
  @IBOutlet var lblUserManageableValue: UILabel!
  @IBOutlet var lblLocationAcuracyValue: UILabel!
  @IBOutlet var lblResolutionValue: UILabel!
  @IBOutlet var lblLoggingFrequencyValue: UILabel!
  @IBOutlet var lblLocationActivityTypeValue: UILabel!
  @IBOutlet var lblPausesLocationUpdatesAutomatically: UILabel!
  
  @IBOutlet var lblVersion: UILabel!
  
  var doNotLoadSettings:Bool = false
  
  var locationTrack: Int                      = 0
  var locationAccuracy: Int                   = 0
  var locationResolution: Int                 = 10
  var locationUserManageable: Int             = 1
  var locationLoggingFrequency: Int           = 60
  var locationActivityType: Int               = 1
  var pausesLocationUpdatesAutomatically: Int = 1
  
  var currentLocation: CLLocation?
  var lastLoggingTime: Date?
  
  var locationManager: CLLocationManager!
  
  lazy var controller = UIAlertController()
  
  override open var supportedInterfaceOrientations : UIInterfaceOrientationMask
  {
    return .all
  }
  
  @objc private func settingsChanged(notification: NSNotification)
  {
    if !self.doNotLoadSettings
    {
      self.loadSettings()
    }
  }
  
  private func loadSettings()
  {
    var serverConfig:[String: AnyObject]
  
    if let dictionary = UserDefaults.standard.object(forKey: "com.apple.configuration.managed")
    {
      serverConfig = dictionary as! [String : AnyObject]
    
      let _sc1:String = serverConfig["GeoLocationTrackLocation"]             as? String ?? ""
      let _sc2:String = serverConfig["GeoLocationPreferredAccuracyCode"]     as? String ?? ""
      let _sc3:String = serverConfig["GeoLocationResolutionMeters"]          as? String ?? ""
      let _sc4:String = serverConfig["GeoLocationUpdateUserManageable"]      as? String ?? ""
      let _sc5:String = serverConfig["GeoLocationLoggingFrequencySeconds"]   as? String ?? ""
      let _sc6:String = serverConfig["GeoLocationActivityType"]              as? String ?? ""
      let _sc7:String = serverConfig["GeoLocationPausesUpdateAutomatically"] as? String ?? ""
    
      if _sc1 != ""
      {
        self.locationTrack = Int(_sc1) ?? 0
      }
    
      if _sc2 != ""
      {
        self.locationAccuracy = Int(_sc2) ?? 0
      }
    
      if _sc3 != ""
      {
        self.locationResolution = Int(_sc3) ?? 10
      }

      if _sc4 != ""
      {
        self.locationUserManageable = Int(_sc4) ?? 1
      }
    
      if _sc5 != ""
      {
        self.locationLoggingFrequency = Int(_sc5) ?? 60
      }
  
      if _sc6 != ""
      {
        self.locationActivityType = Int(_sc6) ?? 1
      }
    
      if _sc7 != ""
      {
        self.pausesLocationUpdatesAutomatically = Int(_sc7) ?? 1
      }
    }
  
    if self.locationUserManageable == 1
    {
      self.swLocation.isEnabled = true
    }
    else
    {
      self.swLocation.isEnabled = false
    }
  
    switch self.locationAccuracy
    {
      case 1:
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.lblLocationAcuracyValue.text = "Best For Navigation"
      case 2:
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.lblLocationAcuracyValue.text = "Best"
      case 3:
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.lblLocationAcuracyValue.text = "Nearest Ten Meters"
      case 4:
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.lblLocationAcuracyValue.text = "Hundred Meters"
      case 5:
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
       self.lblLocationAcuracyValue.text = "Kilometer"
      case 6:
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.lblLocationAcuracyValue.text = "Three Kilometers"
      default:
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.lblLocationAcuracyValue.text = "Best"
    }
  
    switch self.locationActivityType
    {
      case 1:
      self.locationManager.activityType = CLActivityType.other
      self.lblLocationActivityTypeValue.text = "Other"
      case 2:
      self.locationManager.activityType = CLActivityType.automotiveNavigation
      self.lblLocationActivityTypeValue.text = "Automotive Navigation"
      case 3:
      self.locationManager.activityType = CLActivityType.fitness
      self.lblLocationActivityTypeValue.text = "Fitness"
      case 4:
      self.locationManager.activityType = CLActivityType.otherNavigation
      self.lblLocationActivityTypeValue.text = "Other Navigation"
      case 5:
      self.locationManager.activityType = CLActivityType.airborne
      self.lblLocationActivityTypeValue.text = "Airborne"
      default:
      self.locationManager.activityType = CLActivityType.other
      self.lblLocationActivityTypeValue.text = "Other"
    }
  
    self.locationManager.distanceFilter = Double(self.locationResolution)
    self.lblResolutionValue.text = "\(self.locationResolution) Meters"
  
    self.lblUserManageableValue.text = self.locationUserManageable == 1 ? "Yes" : "No"
  
    self.locationManager.pausesLocationUpdatesAutomatically = self.pausesLocationUpdatesAutomatically == 1 ? true : false
    self.lblPausesLocationUpdatesAutomatically.text = self.pausesLocationUpdatesAutomatically == 1 ? "Yes" : "No"
  
    self.lblLoggingFrequencyValue.text = "\(self.locationLoggingFrequency) Seconds"
  
    if self.locationTrack == 1
    {
      self.lblLocationTrackingEnabledValue.text = "Location Tracking Enabled"
    
      if self.swLocation.isOn == false
      {
        self.swLocation.isOn = true
      }
    
      self.lastLoggingTime = Calendar.current.date(byAdding: .minute, value: -2 * self.locationLoggingFrequency, to: Date())!
      self.locationManager.startUpdatingLocation()
    }
    else
    {
      self.lblLocationTrackingEnabledValue.text = "Location Tracking Disabled"
      
      if self.swLocation.isOn == true
      {
        self.swLocation.isOn = false
      }
    
      self.locationManager.stopUpdatingLocation()
    }
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.lastLoggingTime = Date()
    
    self.locationManager = CLLocationManager()
    self.locationManager.delegate = self
    self.locationManager.allowsBackgroundLocationUpdates = true
    self.locationManager.pausesLocationUpdatesAutomatically = false
    self.locationManager.requestAlwaysAuthorization()
    
    self.loadSettings()
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.settingsChanged), name: UserDefaults.didChangeNotification, object: nil)

    self.lblVersion.text! +=  (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
  }
  
  func isLocationChanged(_ locations: CLLocation) -> Bool
  {
    let _elapsed:TimeInterval = Date().timeIntervalSince(self.lastLoggingTime ?? Date())
  
    if (Int(_elapsed.rounded())) >= self.locationLoggingFrequency
    {
      if Int(locations.horizontalAccuracy) <= self.locationResolution
      {
        let _curLat:Double = Double(round(10000 * (currentLocation?.coordinate.latitude ?? 0.0) / 10000))
        let _curLon:Double = Double(round(10000 * (currentLocation?.coordinate.longitude ?? 0.0) / 10000))
      
        if
          _curLat == Double(round(10000 * locations.coordinate.latitude) / 10000)
          &&
          _curLon == Double(round(10000 * locations.coordinate.longitude) / 10000)
        {
          return false
        }
        else
        {
          return true
        }
      }
      else
      {
        return true
      }
    }
    else
    {
      return false
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
  {
    guard let newLocation = locations.last else {return}
    guard self.isLocationChanged(newLocation) else {return}
    
    self.doNotLoadSettings = true
    self.currentLocation = locations.last
  
    var feedback:[String: AnyObject]
    var geolocations: Array<AnyObject>
    let defaults = UserDefaults.standard
    
    
    if defaults.object(forKey: "com.apple.feedback.managed") != nil
    {
      feedback = defaults.dictionary(forKey: "com.apple.feedback.managed")! as [String : AnyObject]
    }
    else
    {
      feedback = Dictionary()
    }
  
    if feedback.index(forKey: "GeoLocations") != nil
    {
      geolocations = (feedback["GeoLocations"] as! NSArray) as Array
    }
    else
    {
      geolocations = Array()
    }
  
    var loc = Dictionary<String,AnyObject>()
    loc["SampledAt"] = newLocation.timestamp                   as AnyObject?
    loc["Lon"]       = Float(newLocation.coordinate.longitude) as AnyObject?
    loc["Lat"]       = Float(newLocation.coordinate.latitude)  as AnyObject?
  
    if geolocations.count <= 10000
    {
      geolocations.append(loc as AnyObject)
      feedback["GeoLocations"] = geolocations as AnyObject?
      print(newLocation.timestamp )
      print(geolocations.count)
    }
  
    defaults.set(feedback, forKey: "com.apple.feedback.managed")
    defaults.synchronize()
    
    self.lastLoggingTime = Date()
  
    self.doNotLoadSettings = false
  }
  
  func displayAlertWithTitle(_ title: String, message: String)
  {
    controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in }))
  
    present(controller, animated: true, completion: nil)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
  {
    switch CLLocationManager.authorizationStatus()
    {
      case .authorizedWhenInUse:
        displayAlertWithTitle("Allow Location Access 'While Using the App'", message: "Allow Location Access should be set to 'Always'! Manage your locations services in settings!")
        break
      case .denied:
        displayAlertWithTitle("Allow Location Access 'Never'", message: "Allow Location Access should be set to 'Always'! Manage your locations services in settings!")
        break
      case .notDetermined:
        displayAlertWithTitle("Allow Location Access 'Ask Next Time Or When I Share'", message: "Allow Location Access should be set to 'Always'! Manage your locations services in settings!")
        break
      case .restricted:
        displayAlertWithTitle("Allow Location Access 'Ask Next Time Or When I Share'", message: "Allow Location Access should be set to 'Always'! Manage your locations services in settings!")
        break
      case .authorizedAlways:
        break
      @unknown default:
        break
    }
  }

  @IBAction func swLocation_ValueChanged(_ sender: UISwitch)
  {
    if sender.isOn
    {
      self.lblLocationTrackingEnabledValue.text = "Location Tracking Enabled"
      
      self.locationTrack = 1
    
      self.lastLoggingTime = Calendar.current.date(byAdding: .minute, value: -2 * self.locationLoggingFrequency, to: Date())!
    
      self.locationManager.startUpdatingLocation()
    }
    else
    {
      self.lblLocationTrackingEnabledValue.text = "Location Tracking Disabled"

      self.locationTrack = 0
    
      self.locationManager.stopUpdatingLocation()
    }
  }
}

