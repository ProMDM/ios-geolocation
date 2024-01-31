# ios-geolocation

## Keys
    GeoLocationTrackLocation - start (1) or stop (0) location tracking
    
    GeoLocationPreferredAccuracy - 
      1 – The highest possible accuracy that uses additional sensor data to facilitate navigation apps
      2 – The best level of accuracy available
      3 – Accurate to within ten meters of the desired target
      4 – Accurate to within one hundred meters
      5 – Accurate to the nearest kilometer
      6 – Accurate to the nearest three kilometers
      Other values -  Fall back to value 1
      
    GeoLocationResolutionMeters - location accuracy in meters
    
    GeoLocationLoggingFrequencySeconds - the frequency of collecting data in seconds
    
    GeoLocationUpdateUserManageable - can the user turn the location tracking on or off - yes (1) or no (0)
    
    GeoLocationActivityType - 
      1 – The value that indicates the app is using location manager for an unspecified activity.
      2 – The value that indicates positioning in an automobile following a road network.
      3 – The value that indicates positioning during dedicated fitness sessions, such as walking workouts, running workouts, cycling workouts, and so on.
      4 – The value that indicates positioning for activities that don’t or may not adhere to roads such as cycling, scooters, trains, boats and off-road vehicles
      5 – The value that indicates activities in the air
      Other values -  Fall back to value 1 
      
    GeoLocationPausesUpdateAutomatically - allowing the location manager to pause updates can improve battery life on the target device without sacrificing location 
    data (setting this property to true causes the location manager to pause updates (and powers down the appropriate hardware) at times when the location data is 
    unlikely to change) - yes (1) or no (0)


## Managed configurations
### Start
    <key>GeoLocationTrackLocation</key>
    <string>1</string>
    <key>GeoLocationPreferredAccuracyCode</key>
    <string>1</string>
    <key>GeoLocationResolutionMeters</key>
    <string>50</string>
    <key>GeoLocationLoggingFrequencySeconds</key>
    <string>30</string> 
    <key>GeoLocationUpdateUserManageable</key>
    <string>0</string>
    <key>GeoLocationActivityType</key>
    <string>3</string>
    <key>GeoLocationPausesUpdateAutomatically</key>
    <string>0</string>

### Stop
    <key>GeoLocationTrackLocation</key> 
    <string>0</string>
