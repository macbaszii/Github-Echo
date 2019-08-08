import UIKit

protocol ImageDownloader {
    func downloadImage(with url: URL, completion: @escaping ((Result<UIImage>) -> Void))
}

final class ImageDownloaderImplementation: ImageDownloader {
    let networkConnector: NetworkConnector

    init(networkConnector: NetworkConnector = NetworkConnectorImplementation()) {
        self.networkConnector = networkConnector
    }

    enum ImageDownloadError: Error {
        case downloadError(message: String)
    }

    func downloadImage(with url: URL, completion: @escaping ((Result<UIImage>) -> Void)) {
        let task = networkConnector.request(url: url) { result in
            switch result {
            case .success(let result):
                guard let image = UIImage(data: result.data) else {
                    completion(.failure(
                        ImageDownloadError.downloadError(message: "Invalid Image Data"))
                    )
                    return
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(
                    ImageDownloadError.downloadError(message: error.localizedDescription))
                )
            }
        }

        task.resume()
    }
}
