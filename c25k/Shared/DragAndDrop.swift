//
//  DragAndDrop.swift
//  c25k
//
//  Created by Avesta Barzegar on 2023-06-25.
//

import SwiftUI

struct MyDropDelegate<Data: Equatable>: DropDelegate {

	let item: Data
	@Binding var items: [Data]
	@Binding var draggedItem: Data?

	func performDrop(info: DropInfo) -> Bool {
		return true
	}

	func dropEntered(info: DropInfo) {
		guard let draggedItem = self.draggedItem else {
			return
		}

		if draggedItem != item {
			let from = items.firstIndex(of: draggedItem)!
			let to = items.firstIndex(of: item)!
			withAnimation(.default) {
				self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
			}
		}
	}
}
