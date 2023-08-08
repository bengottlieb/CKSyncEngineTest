//
//  Synchronizer.FetchIntegrator.swift
//  CKSyncEngineTest
//
//  Created by Ben Gottlieb on 8/8/23.
//

import Foundation
import CloudKit
import SwiftData
import Observation

extension Synchronizer {
	actor FetchIntegrator: ModelActor {
		let executor: any ModelExecutor
		
		init(_ container: ModelContainer) {
			 let modelContext = ModelContext(container)
			 executor = DefaultModelExecutor(context: modelContext)
		}
		
		func integrate(changes: CKSyncEngine.Event.FetchedRecordZoneChanges) {
			let context = executor.context
			for change in changes.modifications {
				do {
					guard let date = change.record["CD_gmtDate"] as? Date else { continue }
					let existing = try context.record(forDate: date)
					existing.load(from: change.record)
				} catch {
					print("Failed to look up local version of \(change)")
				}
			}
						
			try? context.save()
		}
		
	}
}
