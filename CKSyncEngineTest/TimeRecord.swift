//
//  TimeRecord.swift
//  CKSyncEngineTest
//
//  Created by Ben Gottlieb on 8/6/23.
//

import Foundation
import SwiftData
import Suite

@Model class TimeRecord {
	var timestampString = ""
	var gmtDate: Date = Date().midnight.addingTimeInterval(-TimeInterval(TimeZone.current.secondsFromGMT()))
	var isRunning: Bool { timestamps.count % 2 != 0 }
	
	@Transient var timestamps: [TimeInterval] {
		get { timestampString.components(separatedBy: ",").compactMap { TimeInterval($0) }}
		set { timestampString = newValue.map { "\($0)" }.joined(separator: ",") }
	}
	
	@Transient var dayString: String {
		gmtDate.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT())).formatted()
	}
	
	init() {
		
	}
	
	func start() {
		if isRunning { return }
		
		timestamps.append(Date.now.timeIntervalSince(gmtDate))
	}

	func stop() {
		if !isRunning { return }
		
		timestamps.append(Date.now.timeIntervalSince(gmtDate))
	}

	
	static var sample = TimeRecord()
}
