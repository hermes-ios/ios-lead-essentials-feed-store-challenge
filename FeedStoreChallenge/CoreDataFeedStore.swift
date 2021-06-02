//
//  CoreDataFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Alex Puz on 6/1/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
	
	private let container: NSPersistentContainer
	public init(bundle: Bundle = .main) throws {
		container = try NSPersistentContainer.load(modelName: "FeedStoreChallenge", from: bundle)
	}
	
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
	}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
	}
	
	public func retrieve(completion: @escaping RetrievalCompletion) {
		completion(.empty)
	}
}

private extension NSPersistentContainer {
	enum CoreDataFeedStoreError: Error {
		case modelNotFound
		case persistanceStoreError(Error)
	}
	
	static func load(modelName: String, from bundle: Bundle) throws -> NSPersistentContainer {
		guard let model = NSManagedObjectModel.with(name: modelName, in: bundle) else {
			throw CoreDataFeedStoreError.modelNotFound
		}
		
		let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
		var persistanceStoreError: Error?
		container.loadPersistentStores { persistanceStoreError = $1 }
		try persistanceStoreError.map { throw CoreDataFeedStoreError.persistanceStoreError($0) }
		
		return container
	}
}

private extension NSManagedObjectModel {
	
	static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
		bundle.url(forResource: name, withExtension: "momd")
			.flatMap(NSManagedObjectModel.init(contentsOf:))
	}
}
