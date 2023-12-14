//
//  TripInfoResponses.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import Foundation

// MARK: - TripInfoResponses
struct TripInfoResponses: Codable {
    let availability: Availability?
    let description: TripInfoResponsesDescription?
    let passes: [Pass]?
    let prices: Prices?
    let route: [Route]?
    let shift: Shift?
    let vehicle: Vehicle?
}

extension TripInfoResponses {
    static func loadMockData() -> TripInfoResponses? {
        // Get the file URL of the JSON file
        guard let fileURL = Bundle.main.url(forResource: "TripInfo", withExtension: "json") else {
            print("JSON file not found")
            return nil
        }
        
        do {
            // Read the contents of the JSON file
            let data = try Data(contentsOf: fileURL)
            
            // Create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            // Decode the JSON data into the MyData struct
            let decodedData = try decoder.decode(TripInfoResponses.self, from: data)
            
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
}

// MARK: - Availability
struct Availability: Codable {
    let originLocationtimeID: AvailabilityOriginLocationtimeID?

    enum CodingKeys: String, CodingKey {
        case originLocationtimeID = "{origin_locationtime_id}"
    }
}

// MARK: - AvailabilityOriginLocationtimeID
struct AvailabilityOriginLocationtimeID: Codable {
    let destinationLocationtimeID: DestinationLocationtimeID?

    enum CodingKeys: String, CodingKey {
        case destinationLocationtimeID = "{destination_locationtime_id}"
    }
}

// MARK: - DestinationLocationtimeID
struct DestinationLocationtimeID: Codable {
    let bicycle, seat, wheelchair: Int?
}

// MARK: - TripInfoResponsesDescription
struct TripInfoResponsesDescription: Codable {
    let calendarDate, notes: String?
    let notesDetails: NotesDetails?
    let patternID: Int?
    let routeNumber, type: String?

    enum CodingKeys: String, CodingKey {
        case calendarDate = "calendar_date"
        case notes
        case notesDetails = "notes_details"
        case patternID = "pattern_id"
        case routeNumber = "route_number"
        case type
    }
}

// MARK: - NotesDetails
struct NotesDetails: Codable {
    let displayedOnHomepage, isPublic: Bool?
    let renderedNotes, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case displayedOnHomepage = "displayed_on_homepage"
        case isPublic = "is_public"
        case renderedNotes = "rendered_notes"
        case updatedAt = "updated_at"
    }
}

// MARK: - Pass
struct Pass: Codable {
    let cancellable: Bool?
    let code, customerUid, email: String?
    let id: Int?
    let legs: [Leg]?
    let mobileNumber, name: String?
    let orderDate: String?
    let orderUid: String?
    let price: Int?
    let status: String?
    let tickets: Tickets?

    enum CodingKeys: String, CodingKey {
        case cancellable, code
        case customerUid = "customer_uid"
        case email, id, legs
        case mobileNumber = "mobile_number"
        case name
        case orderDate = "order_date"
        case orderUid = "order_uid"
        case price, status, tickets
    }
}

// MARK: - Leg
struct Leg: Codable {
    let arrival: Arrival?
    let boardingData: BoardingData?
    let departure: Arrival?
    let description: LegDescription?
    let destination, origin: Destination?
    let tripNotes: TripNotes?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case arrival
        case boardingData = "boarding_data"
        case departure, description, destination, origin
        case tripNotes = "trip_notes"
        case type
    }
}

// MARK: - Arrival
struct Arrival: Codable {
    let actual, estimated: String?
    let scheduled: String
}

// MARK: - BoardingData
struct BoardingData: Codable {
    let checkedIn: Tickets?
    let confirmationMethod: String?
    let String: String?
    let noShow: Tickets?

    enum CodingKeys: String, CodingKey {
        case checkedIn = "checked_in"
        case confirmationMethod = "confirmation_method"
        case String
        case noShow = "no_show"
    }
}

// MARK: - Tickets
struct Tickets: Codable {
    let adult, bicycle, child, concession: Int?
    let wheelchair, youngChild: Int?

    enum CodingKeys: String, CodingKey {
        case adult, bicycle, child, concession, wheelchair
        case youngChild = "young_child"
    }
}

// MARK: - LegDescription
struct LegDescription: Codable {
    let amenities: Amenities?
    let colour, destinationBoard, numberPlate, descriptionOperator: String?
    let vehicleType: String?

    enum CodingKeys: String, CodingKey {
        case amenities, colour
        case destinationBoard = "destination_board"
        case numberPlate = "number_plate"
        case descriptionOperator = "operator"
        case vehicleType = "vehicle_type"
    }
}

// MARK: - Amenities
struct Amenities: Codable {
    let hasToilet, hasWifi: Bool?

    enum CodingKeys: String, CodingKey {
        case hasToilet = "has_toilet"
        case hasWifi = "has_wifi"
    }
}

// MARK: - Destination
struct Destination: Codable {
    let active: Bool?
    let areaID: Int?
    let atcoCode, code, codeDetail, description: String?
    let detailedName, direction, googlePlaceID: String?
    let id: Int?
    let lat, lon: Double?
    let localName: String?
    let locationTimeID: Int?
    let name, regionName, type: String?

    enum CodingKeys: String, CodingKey {
        case active
        case areaID = "area_id"
        case atcoCode = "atco_code"
        case code
        case codeDetail = "code_detail"
        case description
        case detailedName = "detailed_name"
        case direction
        case googlePlaceID = "google_place_id"
        case id, lat
        case localName = "local_name"
        case locationTimeID = "location_time_id"
        case lon, name
        case regionName = "region_name"
        case type
    }
}

// MARK: - TripNotes
struct TripNotes: Codable {
    let content: String?
    let isPublic: Bool?
    let renderedContent, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case content
        case isPublic = "is_public"
        case renderedContent = "rendered_content"
        case updatedAt = "updated_at"
    }
}

// MARK: - Prices
struct Prices: Codable {
    let originLocationtimeID: PricesOriginLocationtimeID?

    enum CodingKeys: String, CodingKey {
        case originLocationtimeID = "{origin_locationtime_id}"
    }
}

// MARK: - PricesOriginLocationtimeID
struct PricesOriginLocationtimeID: Codable {
    let destinationLocationtimeID: Tickets?

    enum CodingKeys: String, CodingKey {
        case destinationLocationtimeID = "{destination_locationtime_id}"
    }
}

// MARK: - Route
struct Route: Codable, Identifiable {
    let allowBoarding, allowDropOff: Bool
    let arrival: Arrival
    let bookable: String?
    let bookingCutOffMins: Int
    let departure: Arrival
    let id: Int
    let location: Location
    let preBookedOnly, skipped: Bool

    enum CodingKeys: String, CodingKey {
        case allowBoarding = "allow_boarding"
        case allowDropOff = "allow_drop_off"
        case arrival, bookable
        case bookingCutOffMins = "booking_cut_off_mins"
        case departure, id, location
        case preBookedOnly = "pre_booked_only"
        case skipped
    }
}

// MARK: - Location
struct Location: Codable {
    let atcoCode: String?
    let bookableFrom, bookableUntil: String?
    let description, direction, googlePlaceID: String?
    let detailedName: String
    let id: Int
    let lat, lon: Double?
    let name, regionName, type: String
    let timezone: String?

    enum CodingKeys: String, CodingKey {
        case atcoCode = "atco_code"
        case bookableFrom = "bookable_from"
        case bookableUntil = "bookable_until"
        case description
        case detailedName = "detailed_name"
        case direction
        case googlePlaceID = "google_place_id"
        case id, lat, lon, name
        case regionName = "region_name"
        case timezone, type
    }
}

// MARK: - Shift
struct Shift: Codable {
    let actualEnd, actualStart: String?
    let driver: Driver?
    let id: Int?
    let scheduledEnd, scheduledStart: String?
    let trips: [Int]?

    enum CodingKeys: String, CodingKey {
        case actualEnd = "actual_end"
        case actualStart = "actual_start"
        case driver, id
        case scheduledEnd = "scheduled_end"
        case scheduledStart = "scheduled_start"
        case trips
    }
}

// MARK: - Driver
struct Driver: Codable {
    let dateOfBirth, email: String?
    let id: Int?
    let mobileNumber, name, postcode, preferredName: String?
    let uid: String?

    enum CodingKeys: String, CodingKey {
        case dateOfBirth = "date_of_birth"
        case email, id
        case mobileNumber = "mobile_number"
        case name, postcode
        case preferredName = "preferred_name"
        case uid
    }
}

// MARK: - Vehicle
struct Vehicle: Codable {
    let bicycle: Int?
    let brand, colour: String?
    let currentBatteryCapacity: Int?
    let gps: Gps?
    let hasToilet, hasWifi: Bool?
    let id, idealBatteryCapacity: Int?
    let ipadTelematics: IpadTelematics?
    let isBackupVehicle: Bool?
    let name: String?
    let ownerID: Int?
    let plateNumber: String?
    let seat: Int?
    let secondaryGps: SecondaryGps?
    let targetStateOfCharge: Int?
    let vehicleTelematics: VehicleTelematics?
    let wheelchair: Int?

    enum CodingKeys: String, CodingKey {
        case bicycle, brand, colour
        case currentBatteryCapacity = "current_battery_capacity"
        case gps
        case hasToilet = "has_toilet"
        case hasWifi = "has_wifi"
        case id
        case idealBatteryCapacity = "ideal_battery_capacity"
        case ipadTelematics = "ipad_telematics"
        case isBackupVehicle = "is_backup_vehicle"
        case name
        case ownerID = "owner_id"
        case plateNumber = "plate_number"
        case seat
        case secondaryGps = "secondary_gps"
        case targetStateOfCharge = "target_state_of_charge"
        case vehicleTelematics = "vehicle_telematics"
        case wheelchair
    }
}

// MARK: - Gps
struct Gps: Codable {
    let acceleration: Acceleration?
    let elevation, heading: Double?
    let lastUpdated: String?
    let latitude, longitude, speed: Double?

    enum CodingKeys: String, CodingKey {
        case acceleration, elevation, heading
        case lastUpdated = "last_updated"
        case latitude, longitude, speed
    }
}

// MARK: - Acceleration
struct Acceleration: Codable {
    let x, y, z: String?
}

// MARK: - IpadTelematics
struct IpadTelematics: Codable {
    let batteryPercentage, batteryState, isConnectedToNFCReader, isConnectedToQrCodeScanner: BatteryPercentage?
    let isUsingWifi, thermalState: BatteryPercentage?

    enum CodingKeys: String, CodingKey {
        case batteryPercentage = "battery_percentage"
        case batteryState = "battery_state"
        case isConnectedToNFCReader = "is_connected_to_nfc_reader"
        case isConnectedToQrCodeScanner = "is_connected_to_qr_code_scanner"
        case isUsingWifi = "is_using_wifi"
        case thermalState = "thermal_state"
    }
}

// MARK: - BatteryPercentage
struct BatteryPercentage: Codable {
    let asOf: String?
    let value: Int?

    enum CodingKeys: String, CodingKey {
        case asOf = "as_of"
        case value
    }
}

// MARK: - SecondaryGps
struct SecondaryGps: Codable {
    let heading: Double?
    let lastUpdated: String?
    let latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case heading
        case lastUpdated = "last_updated"
        case latitude, longitude
    }
}

// MARK: - VehicleTelematics
struct VehicleTelematics: Codable {
    let batteryCurrent, batteryPercentage, batteryVoltage, chargerStatus: BatteryPercentage?
    let highestBatteryTemp, insideTemperature, lowestBatteryTemp, odometerReading: BatteryPercentage?
    let outsideTemperature: BatteryPercentage?

    enum CodingKeys: String, CodingKey {
        case batteryCurrent = "battery_current"
        case batteryPercentage = "battery_percentage"
        case batteryVoltage = "battery_voltage"
        case chargerStatus = "charger_status"
        case highestBatteryTemp = "highest_battery_temp"
        case insideTemperature = "inside_temperature"
        case lowestBatteryTemp = "lowest_battery_temp"
        case odometerReading = "odometer_reading"
        case outsideTemperature = "outside_temperature"
    }
}
