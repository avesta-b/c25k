//
//  ContentView.swift
//  c25k
//
//  Created by Avesta Barzegar on 2023-06-24.
//

import ComposableArchitecture
import SwiftUI

struct TemplateScreenFeature: Reducer {

	struct State: Equatable {
		enum Mode {
			case edit
			case normal

			var transition: Mode {
				switch self {
				case .edit:
					return .normal
				case .normal:
					return .edit
				}
			}
		}
		var mode: Mode
		var templateItems: ExerciseTemplateItems
	}

	enum Action {
		case didToggleMode
		case didPressAdd
		case templateItems(TemplateItemsFeature.Action)
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .didPressAdd:
				return .none
			case .didToggleMode:
				state.mode = state.mode.transition
				return .none
			case .templateItems(_):
				return .none
			}
		}
		Scope(state: \.templateItems, action: /Action.templateItems) {
			TemplateItemsFeature()
		}
	}
}

struct TemplateScreenView: View {

	let store: StoreOf<TemplateScreenFeature>

	var body: some View {

		WithViewStore(store, observe: \.mode) { viewStore in
			NavigationStack {
				VStack {
					switch viewStore.state {
					case .edit:
						Text("Edit mode")
					case .normal:
						TemplateItemsView(
							store: store.scope(
								state: \.templateItems,
								action: TemplateScreenFeature.Action.templateItems)
						)
					}
				}
				.navigationTitle(Strings.templates)
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							print("tapped me")
						} label: {
							Image(systemName: "plus")
								.foregroundColor(.mint)
						}
					}
					ToolbarItem(placement: .navigationBarLeading) {
						Button {
							viewStore.send(.didToggleMode)
						} label: {
							Image(systemName: "slider.horizontal.3")
								.foregroundColor(.mint)
						}
					}
				}
			}
		}
	}
}

struct TemplateScreenView_Previews: PreviewProvider {

	private static let state = TemplateItemsFeature.State(exercises: [
		.init(isExpanded: true, title: "Week 1", exerciseIntervals: [.init(type: .run, duration: 90), .init(type: .cooldown, duration: 90)]),
		.init(isExpanded: true, title: "Week 2", exerciseIntervals: [.init(type: .run, duration: 120), .init(type: .cooldown, duration: 90)])
	])

	static var previews: some View {
		TemplateScreenView(
			store: Store(initialState:
							TemplateScreenFeature.State(mode: .normal, templateItems: Self.state),
						 reducer: TemplateScreenFeature())
		)
	}
}


