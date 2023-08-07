//
//  RecordRow.swift
//  CKSyncEngineTest
//
//  Created by Ben Gottlieb on 8/7/23.
//

import SwiftUI
import SwiftData

struct RecordRow: View {
	let record: TimeRecord
	
	var body: some View {
		HStack {
			Text("\(record.dayString) (\(record.timestamps.count))")
			
			if record.isRunning {
				Button("Stop") {
					record.stop()
				}
			} else {
				Button("Start") {
					record.start()
				}
			}
			
			Spacer()
			if !record.timestamps.isEmpty {
				Button("Reset") {
					record.reset()
				}
			}
		}
	}
}
