//
//  GeoLocation.swift
//  
//
//  Created by Saroar Khandoker on 12.10.2020.
//

import Foundation
import Vapor
import Fluent
import FluentMongoDriver

public final class GeoLocation: Model, Content {
    public static var schema = "geo_locations"

    public init() {}
    
    public init(id: ObjectId? = nil, addressName: String, coordinates: [Double], geoType: GeoType, eventID: Event.IDValue) {
        self.id = id
        self.addressName = addressName
        self.coordinates = coordinates
        self.type = geoType
        self.$event.id = eventID
    }
    
    @ID(custom: "id") public var id: ObjectId?
    @Field(key: "addressName") public var addressName: String
    @Field(key: "type") public var type: GeoType
    @Field(key: "coordinates") public var coordinates: [Double]
    
    @Parent(key: "eventId") public var event: Event

    @Timestamp(key: "createdAt", on: .create) public var createdAt: Date?
    @Timestamp(key: "updatedAt", on: .update) public var updatedAt: Date?
    @Timestamp(key: "deletedAt", on: .delete) public var deletedAt: Date?

}

extension GeoLocation {
    
    public var response: Item {
        .init(self)
    }
    
    public struct Item: Content {
        internal init(_ geoLocation: GeoLocation) {
            self.id = geoLocation.id
            self.event = geoLocation.event
            self.addressName = geoLocation.addressName
            self.type = geoLocation.type
            self.coordinates = geoLocation.coordinates
            self.updatedAt = geoLocation.updatedAt
            self.createdAt = geoLocation.createdAt
            self.deletedAt = geoLocation.deletedAt
        }
        
        public var id: ObjectId?
        public var event: Event
        public var addressName: String
        public var type: GeoType
        public var coordinates: [Double]
        public var updatedAt, createdAt, deletedAt: Date?
    }
}

public enum GeoType: String {
    case Point
    case LineString
    case Polygon
    case MultiPoint
    case MultiLineString
    case MultiPolygon
    case GeometryCollection
}

extension GeoType: Encodable {}
extension GeoType: Decodable {}