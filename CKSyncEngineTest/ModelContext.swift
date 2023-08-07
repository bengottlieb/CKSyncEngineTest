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
	func record(forDate date: Date) throws -> TimeRecord {
		let day = date.midnight.addingTimeInterval(-TimeInterval(TimeZone.current.secondsFromGMT()))
		
		let predicate = #Predicate<TimeRecord> { $0.gmtDate == day }
		let descriptor = FetchDescriptor(predicate: predicate, sortBy: [])
		let fetched = try fetch(descriptor)
		if let first = fetched.first { return first }
		
		let new = TimeRecord()
		new.gmtDate = day
		return new
	}
}
