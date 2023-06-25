//
//  ExerciseInterval.swift
//  c25k
//
//  Created by Avesta Barzegar on 2023-06-25.
//

import ComposableArchitecture
import Foundation

struct ExerciseTemplateItems: Equatable {
	var exercises: IdentifiedArrayOf<ExerciseTemplate>
}

struct ExerciseTemplate: Equatable, Identifiable {
	let id: UUID = UUID()
	var isExpanded: Bool = false
	var title: String
	var exerciseIntervals: [ExerciseInterval]
}

struct ExerciseInterval: Identifiable, Equatable {

	private static let formatter = DateComponentsFormatter()

	let type: IntervalType
	let duration: TimeInterval
	let id: UUID = UUID()

	enum IntervalType: String, CaseIterable {
		case run = "Run"
		case cooldown = "Cooldown"
	}

	var stringValue: String {
		guard let stringValue = Self.formatter.string(from: duration) else {
			assertionFailure("Time interval could somehow not be formatted to a proper duration")
			return "FAILURE"
		}
		return "\(self.type.rawValue) for \(stringValue)"
	}

}
