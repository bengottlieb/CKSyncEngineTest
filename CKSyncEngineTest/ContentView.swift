//
//  ContentView.swift
//  CKSyncEngineTest
//
//  Created by Ben Gottlieb on 8/6/23.
//

import SwiftUI
import SwiftData
import Suite

struct ContentView: View {
	@State var newDate = Date()
	@Environment(\.modelContext) var modelContext
	@Environment(Synchronizer.self) var synchronizer
	
	@Query(sort: \TimeRecord.gmtDate, order: .reverse) private var records: [TimeRecord]

	var body: some View {
		VStack {
			HStack {
				Spacer()
				
				if synchronizer.isSynchronizing {
					ProgressView()
				} else {
					AsyncButton(action: {
						do {
							try await synchronizer.sync()
						} catch {
							print("Failed to sync: \(error)")
						}
						
					}) {
						Image(systemName: "arrow.clockwise")
					}
				}
			}
			.frame(height: 25)
			
			DatePicker("New Day", selection: $newDate, displayedComponents: [.date])
			
			ScrollView {
				ForEach(records) { record  in
					RecordRow(record: record)
				}
			}

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
