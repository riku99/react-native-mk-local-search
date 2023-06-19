import Foundation
import CoreLocation
import MapKit

@objc(LocalSearchManager)
class LocalSearchManager: RCTEventEmitter {
  
  var searchCompleter = MKLocalSearchCompleter()
  var searchLocationResolver: RCTPromiseResolveBlock?
  var searchLocationRjecter: RCTPromiseRejectBlock?
  
  override init() {
    super.init()
    searchCompleter.delegate = self
  }
  
  @objc
  func searchLocations(_ text: String!) {
    DispatchQueue.main.async {
      self.searchCompleter.queryFragment = text
    }
  }
  
  @objc
  func searchCoodinate(_ query: String!, resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = query
    let search = MKLocalSearch(request: searchRequest)
    search.start(completionHandler: {(response, error) in
      guard let response = response else {
        reject("notCoodinateFound", "Coodinate is not found", nil)
        return
      }
      
      let coodinate = response.mapItems[0].placemark.coordinate
      let data = ["latitude": coodinate.latitude, "longitude": coodinate.longitude]
      resolve(data)
    })
  }
  
  @objc
  override func supportedEvents() -> [String]! {
    return ["onUpdatedLocationResults"]
  }
  
  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

extension LocalSearchManager: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    let results = completer.results.compactMap { (result) -> [String: String] in
      return ["title": result.title, "subtitle": result.subtitle]
    }
    
    return sendEvent(withName: "onUpdatedLocationResults", body: results)
  }
}


