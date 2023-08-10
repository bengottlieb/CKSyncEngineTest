//
//  TimeRecord.swift
//  CKSyncEngineTest
//
//  Created by Ben Gottlieb on 8/6/23.
//

import Foundation
import SwiftData
import Suite
import CloudKit

@Model class TimeRecord {
	var createdAt: Date!
	var timestampString: String!
	var gmtDate: Date! 
	var isRunning: Bool { timestamps.count % 2 != 0 }
	
	@Transient var timestamps: [TimeInterval] {
		get { timestampString.components(separatedBy: ",").compactMap { TimeInterval($0) }}
		set { timestampString = newValue.map { "\(Int($0))" }.joined(separator: ",") }
	}
	
	@Transient var dayString: String {
		gmtDate.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT())).formatted()
	}
	
	init(date: Date) {
		self.createdAt = Date()
		self.timestampString = ""
		self.gmtDate = date.midnight.addingTimeInterval(-TimeInterval(TimeZone.current.secondsFromGMT()))
	}
	
	func start() {
		if isRunning { return }
		
		timestamps.append(Date.now.timeIntervalSince(gmtDate))
	}

	func stop() {
		guard let last = timestamps.last else { return }
		
		timestamps.append(Date.now.timeIntervalSince(gmtDate) - last)
	}

	func reset() {
		timestampString = ""
	}
	
	func load(from record: CKRecord) {
		if let stamps = record["CD_timestampString"] as? String {
			timestampString = stamps + "new!"
		}
	}

	
	static var sample = TimeRecord(date: .now)
}
