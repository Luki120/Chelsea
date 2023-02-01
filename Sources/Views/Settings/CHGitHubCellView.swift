import SwiftUI


struct CHGitHubCellView: View {

	@ObservedObject private(set) var viewModel: CHGitHubCellViewModel

	var body: some View {
		HStack {
			Image(uiImage: viewModel.image)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 40, height: 40)
				.clipShape(Circle())

			Text(viewModel.devName)
		}
		.frame(maxWidth: .infinity, alignment: .center)
	}

}
