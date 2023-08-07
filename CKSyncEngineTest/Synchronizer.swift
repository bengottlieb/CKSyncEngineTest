//
//  Synchronizer.swift
//  CKSyncEngineTest
//
//  Created by Ben Gottlieb on 8/7/23.
//

import Foundation
import CloudKit
import SwiftData

final class Synchronizer {
	static var instance: Synchronizer!
	
	let modelContainer: ModelContainer
	static var engine: CKSyncEngine!
	let ckContainer = CKContainer(identifier: "iCloud.con.standalone.cloudkittesting")
	
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
}

extension Synchronizer: CKSyncEngineDelegate {
	func handleEvent(_ event: CKSyncEngine.Event, syncEngine: CKSyncEngine) async {
		switch event {
			
		case .stateUpdate(let update):
			Synchronizer.syncState = update.stateSerialization
//			print("Handle Event: update: \(update)")

		case .accountChange(let account):
//			print("Handle Event: accountChange: \(account)")
			break

		case .fetchedDatabaseChanges(let changes):
			print("Handle Event: fetchedDatabaseChanges: \(changes)")
			break

		case .fetchedRecordZoneChanges(let changes):
			print("Handle Event: fetchedRecordZoneChanges: \(changes)")
			break
		case .sentDatabaseChanges(_):
			break
		case .sentRecordZoneChanges(_):
			break
		case .willFetchChanges(_):
			break
		case .willFetchRecordZoneChanges(_):
			break
		case .didFetchRecordZoneChanges(_):
			break
		case .didFetchChanges(_):
			break
		case .willSendChanges(_):
			break
		case .didSendChanges(_):
			break
		@unknown default:
			break
		}
	}
	
	func nextRecordZoneChangeBatch(_ context: CKSyncEngine.SendChangesContext, syncEngine: CKSyncEngine) async -> CKSyncEngine.RecordZoneChangeBatch? {
		print("nextRecordZoneChangeBatch: \(context)")
		return nil
	}
	
	
}
