//
//  c25kApp.swift
//  c25k
//
//  Created by Avesta Barzegar on 2023-06-24.
//

import ComposableArchitecture
import SwiftUI

@main
struct c25kApp: App {
	var body: some Scene {
		WindowGroup {
			TemplateScreenView(
				store: Store(initialState: TemplateScreenFeature.State(mode: .normal, templateItems: TemplateItemsFeature.State(exercises: [
					.init(title: "Week 1", exerciseIntervals: [.init(type: .run, duration: 90), .init(type: .cooldown, duration: 90)]),
					.init(title: "Week 2", exerciseIntervals: [.init(type: .run, duration: 120), .init(type: .cooldown, duration: 90)])
				])),
							 reducer: TemplateScreenFeature())
			)
		}
	}
}
