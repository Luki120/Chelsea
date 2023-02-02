import SwiftUI


struct CHSettingsView: View {

	let viewModel: CHSettingsViewViewModel

	var body: some View {
		List {
			Section(header: Text("Developers")) {
				HStack {
					ForEach(Array(viewModel.ghCellViewModels.enumerated()), id: \.1.id) { index, viewModel in
						CHGitHubCellView(viewModel: viewModel)
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

			Group {
				Section(footer: SourceCodeButton()) {}

				Section(footer: Text("© 2023 Luki120").font(.caption)) {}
					.padding(.top, -30)
			}
			.frame(maxWidth: .infinity, alignment: .center)
		}
		.listStyle(.insetGrouped)
	}

	@ViewBuilder
	private func SourceCodeButton() -> some View {
		Button("Source Code") {
			viewModel.footerViewModel.onTap()
		}
		.font(.system(size: 16))
		.foregroundColor(.secondary)
	}

}
