import SwiftUI

enum DetailState {
    case loading
    case loaded(DetailCharacter)
    case error
}

enum DetailEvent {
    case onAppear
}

struct DetailCharacterView: View {
    
    @ObservedObject
    private var viewModel: DetailCharacterViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: DetailCharacterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
            case .loaded(let character):
                CharacterInfoView(character: character)
            case .error:
                ErrorView(retryAction: { viewModel.send(.onAppear) })
            }
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
    }
}

struct CharacterInfoView: View {
    let character: DetailCharacter
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: character.imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 100)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            Text(character.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            InfoRow(title: "Race", value: character.race)
            InfoRow(title: "Gender", value: character.gender)
            InfoRow(title: "Status", value: character.status)
            InfoRow(title: "Location", value: character.location)
            InfoRow(title: "Episodes", value: character.countEpisode)
            Spacer()
        }
        .padding()
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(title):")
                .font(.custom("", fixedSize: 20))
                .fontWeight(.medium)
            Text(value)
                .font(.custom("", fixedSize: 20))
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct ErrorView: View {
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Произошла ошибка при загрузке")
                .foregroundColor(.red)
                .font(.headline)
            Button("Повторить") {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
