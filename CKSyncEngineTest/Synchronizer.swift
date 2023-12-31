//
//  Synchronizer.swift
//  CKSyncEngineTest
//
//  Created by Ben Gottlieb on 8/7/23.
//

import Foundation
import CloudKit
import SwiftData
import Observation

@Observable final class Synchronizer {
	static var instance: Synchronizer!
	
	var isSynchronizing = false
	let modelContainer: ModelContainer
	static var engine: CKSyncEngine!
	let ckContainer = CKContainer(identifier: "iCloud.com.standalone.ckenginetesting")
	
	static var syncState: CKSyncEngine.State.Serialization? {
		get { try? CKSyncEngine.State.Serialization.loadJSON(file: .document(named: "syncState")) }
		set { try! newValue?.saveJSON(to: .document(named: "syncState")) }
	}
		
	init(container: ModelContainer) {
		modelContainer = container

		let config = CKSyncEngine.Configuration(database: ckContainer.privateCloudDatabase, stateSerialization: Synchronizer.syncState, delegate: self)
		Self.engine = CKSyncEngine(config)
	}
	
	static func setup(with container: ModelContainer) {
		instance = Synchronizer(container: container)
	}
	
	func sync() async throws {
		try await Self.engine.fetchChanges()
	}
}

extension Synchronizer: CKSyncEngineDelegate {
	func handleEvent(_ event: CKSyncEngine.Event, syncEngine: CKSyncEngine) async {
		switch event {
			
		case .stateUpdate(let update):
			Synchronizer.syncState = update.stateSerialization
			print("State updated")
//			print("Handle Event: update: \(update)")

		case .accountChange(let account):
			print("Handle Event: accountChange: \(account)")

		case .fetchedDatabaseChanges(let changes):
			print("Handle Event: fetchedDatabaseChanges: \(changes)")
			break

		case .fetchedRecordZoneChanges(let changes):
			Task { await FetchIntegrator(modelContainer).integrate(changes: changes) }
//			Task {
//				let context = ModelContext(modelContainer)
//				for change in changes.modifications {
//					do {
//						guard let date = change.record["CD_gmtDate"] as? Date else { continue }
//						let existing = try context.record(forDate: date)
//						existing.load(from: change.record)
//					} catch {
//						print("Failed to look up local version of \(change)")
//					}
//				}
//				
//				try? context.save()
//			}
			
		case .sentDatabaseChanges(_):
			print("Send database changes")
		case .sentRecordZoneChanges(_):
			print("Send zone changes")
		case .willFetchChanges(_):
			print("will fetch changes")
			isSynchronizing = true
		case .willFetchRecordZoneChanges(let changes):
			print("handling \(changes)")
		case .didFetchRecordZoneChanges(let changes):
			print("handling \(changes)")
		case .didFetchChanges(_):
			print("did fetch changes")
			DispatchQueue.main.async {
				self.isSynchronizing = false
			}
		case .willSendChanges(_):
			print("will send changes")
			isSynchronizing = true
		case .didSendChanges(_):
			print("did send changes")
		@unknown default:
			break
		}
	}
	
	func nextRecordZoneChangeBatch(_ context: CKSyncEngine.SendChangesContext, syncEngine: CKSyncEngine) async -> CKSyncEngine.RecordZoneChangeBatch? {
		print("nextRecordZoneChangeBatch: \(context)")
		return nil
	}
	
	
}
