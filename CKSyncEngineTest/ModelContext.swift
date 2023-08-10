//
//  ModelContext.swift
//  CKSyncEngineTest
//
//  Created by Ben Gottlieb on 8/6/23.
//

import Foundation
import SwiftData
import Suite

extension ModelContext {
	func deleteRecord(forDate date: Date) throws {
		let day = date.midnight.addingTimeInterval(-TimeInterval(TimeZone.current.secondsFromGMT()))
		
		let predicate = #Predicate<TimeRecord> { $0.gmtDate == day }
		let descriptor = FetchDescriptor(predicate: predicate, sortBy: [])
		let fetched = try fetch(descriptor)
		if let first = fetched.first { return delete(first) }
	}

	func record(forDate date: Date) throws -> TimeRecord {
		let day = date.midnight.addingTimeInterval(-TimeInterval(TimeZone.current.secondsFromGMT()))
		
		let predicate = #Predicate<TimeRecord> { $0.gmtDate == day }
		let descriptor = FetchDescriptor(predicate: predicate, sortBy: [])
		let fetched = try fetch(descriptor)
		if let first = fetched.first { return first }
		
		let new = TimeRecord(date: day)
		self.insert(new)
		return new
	}
}
