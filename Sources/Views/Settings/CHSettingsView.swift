import SwiftUI

/// Struct to represent the main settings view
struct CHSettingsView: View {

	let viewModel: CHSettingsViewViewModel

	var body: some View {
		List {
			Section(header: Text("Developers")) {
				HStack {
					ForEach(Array(viewModel.ghCellViewModels.enumerated()), id: \.1.id) { index, viewModel in
						CHSettingsGitHubCellView(viewModel: viewModel)
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

			Section(footer: Text("© 2023 Luki120").font(.caption)) {}
				.frame(maxWidth: .infinity, alignment: .center)
		}
		.listStyle(.insetGrouped)
	}

}
