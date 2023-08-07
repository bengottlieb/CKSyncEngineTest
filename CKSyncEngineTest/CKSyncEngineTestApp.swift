//
//  CKSyncEngineTestApp.swift
//  CKSyncEngineTest
//
//  Created by Ben Gottlieb on 8/6/23.
//

import SwiftUI
import SwiftData
import Suite

@main
struct CKSyncEngineTestApp: App {
	let container = try! ModelContainer(for: [TimeRecord.self], .init(url: .document(named: "model.sqlite")))
	
	init() {
		Synchronizer.setup(with: container)
	}
	var body: some Scene {
		WindowGroup {
			ContentView()
				.modelContainer(container)
				.environment(Synchronizer.instance!)
			//				  .modelContainer(for: [TimeRecord.self])
		}
	}
}
