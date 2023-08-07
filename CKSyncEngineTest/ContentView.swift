//
//  ContentView.swift
//  CKSyncEngineTest
//
//  Created by Ben Gottlieb on 8/6/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@State var newDate = Date()
	@Environment(\.modelContext) var modelContext
	@Environment(Synchronizer.self) var synchronizer
	
	@Query(sort: \TimeRecord.gmtDate, order: .reverse) private var records: [TimeRecord]

	var body: some View {
		VStack {
			if synchronizer.isSynchronizing {
				ProgressView()
			}
			ForEach(records) { record  in
				RecordRow(record: record)
			}
			DatePicker("New Day", selection: $newDate, displayedComponents: [.date])
		}
		.padding()
		.onChange(of: newDate) { oldValue, newValue in
			do {
				let newRecord = try modelContext.record(forDate: newDate)
				modelContext.insert(newRecord)
			} catch {
				print("Failed to look up day: \(error)")
			}
		}
	}
}

#Preview {
	ContentView()
}
