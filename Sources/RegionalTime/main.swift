// RegionalTime
//

import CoreLocation
import Foundation

func die(_ message: String) {
  if let data = (message + "\n").data(using: .utf8) {
    FileHandle.standardError.write(data)
  }
  exit(1)
}

class GeocoderDelegate: NSObject, CLLocationManagerDelegate {
  func geocode(epochSeconds: Double, latitude: Double, longitude: Double) {
    let location = CLLocation(latitude: latitude, longitude: longitude)
    let geoCoder = CLGeocoder()
    let dateToCheck = Date(timeIntervalSince1970: epochSeconds)
    geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
      if let error = error as? CLError {
        switch error.code {
        case .network:
          die(
            "ERROR: Network issue or rate limit exceeded while connecting to the geocoding service."
          )
        case .geocodeFoundNoResult:
          die(
            "ERROR: No location data found for the provided coordinates."
          )
        case .locationUnknown:
          die(
            "ERROR: The location manager was unable to obtain a location value for the coordinates."
          )
        default:
          die(
            "ERROR: An unknown geocoding error occurred: \(error.localizedDescription)."
          )
        }
      } else if let placemark = placemarks?.first {
        if let timeZone = placemark.timeZone {
          let formatter = ISO8601DateFormatter()
          formatter.timeZone = timeZone
          let isoFormattedString = formatter.string(from: dateToCheck)
          print(isoFormattedString)
        } else {
          die("Error: Time zone not found.")
        }
      } else {
        die("Error: No placemarks found.")
      }
      CFRunLoopStop(CFRunLoopGetMain())
    }
    CFRunLoopRun()
  }
}

guard CommandLine.arguments.count == 4,
  let epoch = Double(CommandLine.arguments[1]),
  let lat = Double(CommandLine.arguments[2]),
  let lon = Double(CommandLine.arguments[3])
else {
  die("Usage: GeoTimeUtility <utc_epoch_seconds> <latitude> <longitude>")
  exit(1)
}

let delegate = GeocoderDelegate()
delegate.geocode(epochSeconds: epoch, latitude: lat, longitude: lon)
