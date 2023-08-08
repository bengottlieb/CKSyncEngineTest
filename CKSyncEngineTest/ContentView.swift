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
	@State var addingDay: Date?
	
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
			
			if let addingDay {
				Text("Adding \(addingDay.formatted(date: .abbreviated, time: .omitted))")
			}
			HStack {
				Button("Add a Bunch") {
					var date = Date.now.byAdding(days: -1000)
					
					while date < .now {
						do {
							let newRecord = try modelContext.record(forDate: date)
							modelContext.insert(newRecord)
							date = date.nextDay
							addingDay = date
						} catch {
							print("Failed to add day: \(error)")
						}
					}
				}

				
				Button("Delete a Bunch") {
					var date = Date.now.byAdding(days: -1000)
					
					while date < .now {
						do {
							try modelContext.deleteRecord(forDate: date)
							date = date.nextDay
							addingDay = date
						} catch {
							print("Failed to add day: \(error)")
						}
					}
				}

			}
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
			} catch {
				print("Failed to look up day: \(error)")
			}
		}
	}
}

#Preview {
	ContentView()
}
