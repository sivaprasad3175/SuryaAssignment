//
//  UserModel.swift
//  SuryaTest
//
//  Created by Siva on 04/12/18.
//  Copyright © 2018 Siva. All rights reserved.
//


import Foundation
import CoreData

class User: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case emailId = "emailId"
        case lastName = "lastName"
        case imageUrl = "imageUrl"
        case firstName = "firstName"
    }
    
    // MARK: - Core Data Managed Object
    @NSManaged var emailId: String?
    @NSManaged var lastName: String?
    @NSManaged var imageUrl: String?
    @NSManaged var firstName: String?

    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.emailId = try container.decodeIfPresent(String.self, forKey: .emailId)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)

    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(emailId, forKey: .emailId)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(firstName, forKey: .firstName)
    }
}
