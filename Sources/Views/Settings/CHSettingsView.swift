import SwiftUI


struct CHSettingsView: View {

	let viewModel: CHSettingsViewViewModel

	var body: some View {
		List {
			Section(header: Text("Developers")) {
				HStack {
					ForEach(Array(viewModel.cellViewModels.enumerated()), id: \.1.id) { index, viewModel in
						CHGitHubCellView(viewModel: viewModel)
							.padding(.horizontal, 2.5)
							.onTapGesture {
								viewModel.onTap(viewModel.developer)
							}
						if index == 0 { Divider() }
					}
				}
			}
			Section(footer: Text("© 2023 Luki120")) {}
				.frame(maxWidth: .infinity, alignment: .center)
		}
		.listStyle(.insetGrouped)
	}

}
