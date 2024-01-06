import SwiftUI

/// Struct to represent the main settings view
struct SettingsView: View {

	let viewModel: SettingsViewViewModel

	var body: some View {
		List {
			Section(header: Text("Developers")) {
				HStack {
					ForEach(viewModel.ghCellViewModels, id: \.id) { index, viewModel in
						SettingsGitHubCellView(viewModel: viewModel)
							.padding(.horizontal, 2.5)
							.onTapGesture {
								viewModel.onTap(viewModel.developer)
							}
						if index == 0 { Divider() }
					}
				}
			}

			Section(header: Text("Other apps you may like")) {
				ForEach(viewModel.appCellViewModels) { viewModel in
					VStack(alignment: .leading) {
						Text(viewModel.appName)

						Text(viewModel.appDescription)
							.font(.system(size: 10))
							.foregroundColor(.secondary)
					}
					.onTapGesture {
						viewModel.onTap(viewModel.app)
					}
				}
			}

			Section(header: Text("View the source")) {
				Button("Source Code") {
					viewModel.footerViewModel.onTap()
				}
				.foregroundColor(.primary)
			}

			Section(footer: Text("© 2023-2024 Luki120").font(.caption)) {}
				.frame(maxWidth: .infinity, alignment: .center)
		}
		.listStyle(.insetGrouped)
	}

}

// credits ⇝ https://gist.github.com/leptos-null/e521cbd4a8246ea824d823fc398ba255
private extension ForEach {
	init<Base: Sequence>(_ base: Base, @ViewBuilder content: @escaping (Data.Element) -> Content) where Data == Array<EnumeratedSequence<Base>.Element>, ID == Base.Element, Content: View, ID: Identifiable {
		self.init(Array(base.enumerated()), id: \.element, content: content)
	}

	init<Base: Sequence>(_ base: Base, id: KeyPath<Base.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content) where Data == Array<EnumeratedSequence<Base>.Element>, Content: View {
		let basePath: KeyPath<EnumeratedSequence<Base>.Element, Base.Element> = \.element
		self.init(Array(base.enumerated()), id: basePath.appending(path: id), content: content)
	}
}
