//
//  TemplateItemView.swift
//  c25k
//
//  Created by Avesta Barzegar on 2023-06-24.
//

import ComposableArchitecture
import SwiftUI

struct TemplateItemsFeature: Reducer {

	typealias State = ExerciseTemplateItems

	enum Action {
		case chevronTapped(onSection: UUID)
		case swipeDeleteItem(on: UUID, at: IndexSet)
		case dragMoveItem(on: UUID, from: IndexSet, to: Int)
	}

	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		switch action {
		case let .chevronTapped(onSection: id):
			state.exercises[id: id]?.isExpanded.toggle()
			return .none
		case let .swipeDeleteItem(on: id, at: indices):
			state.exercises[id: id]?.exerciseIntervals.remove(atOffsets: indices)
			if state.exercises[id: id]?.exerciseIntervals.isEmpty ?? true {
				state.exercises.remove(id: id)
			}
			return .none
		case let .dragMoveItem(on: id, from: indices, to: index):
			state.exercises[id: id]?.exerciseIntervals.move(fromOffsets: indices, toOffset: index)
			return .none
		}
	}
}

struct TemplateItemsView: View {

	let store: StoreOf<TemplateItemsFeature>

    var body: some View {
		WithViewStore(store, observe: { $0 } ) { viewStore in
			List {
				ForEach(viewStore.exercises) { exercise in
					Section {
						if exercise.isExpanded {
							ForEach(exercise.exerciseIntervals) { identifiable in
								Text(identifiable.stringValue)
									.padding(vertical: 2)
									.listRowSeparator(.hidden)
							}
							.onDelete { indexSet in
								viewStore.send(
									.swipeDeleteItem(on: exercise.id, at: indexSet))
							}
							.onMove { from, to in
								viewStore.send(
									.dragMoveItem(on: exercise.id, from: from, to: to))
							}
						} else {
							Text(exercise.exerciseIntervals.map { $0.stringValue }.joined(separator: ", "))
								.frame(maxWidth: .infinity, alignment: .leading)
								.padding(vertical: 2)
								.lineLimit(1)
						}
					} header: {
						HStack(alignment: .firstTextBaseline) {
							Text(exercise.title)
							Spacer()
							Image(systemName: exercise.isExpanded ? Images.chevronUp : Images.chevronDown)
						}
						.onTapGesture {
							withAnimation(Animation.easeInOut(duration: 0.3)) {
								viewStore.send(.chevronTapped(onSection: exercise.id))
								return
							}
						}
					}
					.headerProminence(.increased)

				}
			}
		}
    }
}

struct TemplateItemsView_Previews: PreviewProvider {
    static var previews: some View {
		TemplateItemsView(
			store: Store(
				initialState: TemplateItemsFeature.State(exercises: [
					.init(isExpanded: true, title: "Week 1", exerciseIntervals: [.init(type: .run, duration: 90), .init(type: .cooldown, duration: 90)])
				]),
				reducer: TemplateItemsFeature()
			)
		)
    }
}
