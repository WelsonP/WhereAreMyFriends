//
//  Friend.swift
//  WhereAreMyFriends
//
//  Created by Welson Pan on 4/25/19.
//  Copyright © 2019 Welson Pan. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit

struct Friend {

    // MARK: - Properties

    let id: String
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let altitude: Double
    let velocity: Double?

    var location: CLLocation {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        //note: CLLocation also accepts heading and speed, could be useful?
        return CLLocation(
            coordinate: coordinate,
            altitude: altitude,
            horizontalAccuracy: 1,
            verticalAccuracy: 1,
            timestamp: Date())
    }

    func sceneKitCoordinate(relativeTo userLocation: CLLocation) -> SCNVector3 {
        let distance = location.distance(from: userLocation)
        let heading = userLocation.coordinate.getHeading(toPoint: location.coordinate)
        let headingRadians = heading * (.pi/180)

        let distanceScale: Double = 1/140
        var eastWestOffset = distance * sin(headingRadians) * distanceScale
        var northSouthOffset = distance * cos(headingRadians)  * distanceScale

        let altitudeScale: Double = 1/140 //1/20
        var upDownOffset = altitude * altitudeScale

        // scale maximum and minimum position
        let closest = 0.15
        let furthest = 4.0

        let ew = eastWestOffset.magnitude
        let ud = upDownOffset.magnitude
        let ns = northSouthOffset.magnitude
        var factor = 1.0

        let norm = sqrt(ew*ew + ud*ud + ns*ns)
        if norm < closest {
            factor = closest / norm
        } else if norm > furthest {
            factor = furthest / norm
        }

        eastWestOffset *= factor
        upDownOffset *= factor
        northSouthOffset *= factor

        return SCNVector3(eastWestOffset, upDownOffset, -northSouthOffset)
    }

    func sceneKitRotation() -> SCNVector4 {
        return SCNVector4(0, 1, 0, .pi - ((100.0 * (.pi/180)) - .pi))
    }

    // MARK: - Initializers

    init(id: String,
         firstName: String,
         lastName: String,
         longitude: Double,
         latitude: Double,
         altitude: Double = 251.0,
         velocity: Double? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.longitude = longitude
        self.latitude = latitude
        self.altitude = altitude
        self.velocity = velocity
    }
//
//    func loadAdditionalInformation(handler: @escaping (FlightInformation?) -> Void) {
//        if let cachedFlightInfo = Flight.cachedFlightInfo[icao] {
//            handler(cachedFlightInfo.isPrivatePlane ? nil : cachedFlightInfo)
//            return
//        }
//
//        loadJsonFromFlightAware(handler: { json in
//
//            guard let flights = json?["flights"] as? [String: Any],
//                let firstFlight = flights.keys.first,
//                let masterFlight = flights[firstFlight] as? [String: Any] else
//            {
//                handler(nil)
//                Flight.cachedFlightInfo[self.icao] = FlightInformation.privatePlaneIdentifier
//                return
//            }
//
//            let activityLog = masterFlight["activityLog"] as? [String: Any]
//            let flightBody = (activityLog?["flights"] as? [[String: Any]])?.first
//
//            let origin = flightBody?["origin"] as? [String: Any]
//            let originAirportCode = origin?["iata"] as? String
//            let originAirport = origin?["friendlyName"] as? String
//
//            let destination = flightBody?["destination"] as? [String: Any]
//            let destinationAirportCode = destination?["iata"] as? String
//            let destinationAirport = destination?["friendlyName"] as? String
//
//            let takeoffTimes = flightBody?["takeoffTimes"] as? [String: Any]
//            let estimatedTakeoffTimeDouble = takeoffTimes?["estimated"] as? Double
//
//            let landingTimes = flightBody?["landingTimes"] as? [String: Any]
//            let estimatedLandingTimeDouble = landingTimes?["estimated"] as? Double
//
//            let airline = masterFlight["airline"] as? [String: Any]
//            let airlineCode = airline?["icao"] as? String
//            let airlineName = airline?["shortName"] as? String
//
//            let aircraftType = flightBody?["aircraftTypeFriendly"] as? String
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .none
//            dateFormatter.timeStyle = .short
//
//            let estimatedTakeoffTime: String?
//            if let estimatedTakeoffTimeDouble = estimatedTakeoffTimeDouble {
//                let estimatedTakeoffDate = Date(timeIntervalSince1970: estimatedTakeoffTimeDouble)
//                estimatedTakeoffTime = dateFormatter.string(from: estimatedTakeoffDate)
//            } else {
//                estimatedTakeoffTime = nil
//            }
//
//            let estimatedLandingTime: String?
//            if let estimatedLandingTimeDouble = estimatedLandingTimeDouble {
//                let estimatedLandingDate = Date(timeIntervalSince1970: estimatedLandingTimeDouble)
//                estimatedLandingTime = dateFormatter.string(from: estimatedLandingDate)
//            } else {
//                estimatedLandingTime = nil
//            }
//
//            let info = FlightInformation.init(
//                originAirportCode: originAirportCode,
//                originAirport: originAirport,
//                destinationAirportCode: destinationAirportCode,
//                destinationAirport: destinationAirport,
//                departureTime: estimatedTakeoffTime,
//                arrivalTime: estimatedLandingTime,
//                aircraftType: aircraftType,
//                airlineName: airlineName,
//                airlineLogoUrl: "https://flightaware.com/images/airline_logos/90p/\(airlineCode ?? "--").png")
//
//            Flight.cachedFlightInfo[self.icao] = info
//            handler(info)
//        })
//    }
}

// MARK: - CLLocationCoordinate2D + Heading

extension CLLocationCoordinate2D {

    func getHeading(toPoint point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * .pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / .pi }

        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)

        let lat2 = degreesToRadians(point.latitude);
        let lon2 = degreesToRadians(point.longitude);

        let dLon = lon2 - lon1;

        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);

        return radiansToDegrees(radiansBearing)
    }
}

