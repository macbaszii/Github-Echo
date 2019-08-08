import UIKit

protocol ImageCache {
    func cacheImage(with url: URL?, completion: @escaping ((Result<UIImage>) -> Void))
}

final class ImageCacheImplementation: ImageCache {
    let cacher = NSCache<NSString, UIImage>()
    let imageDownloader: ImageDownloader

    init(imageDownloader: ImageDownloader = ImageDownloaderImplementation()) {
        self.imageDownloader = imageDownloader
    }

    func cacheImage(with url: URL?, completion: @escaping ((Result<UIImage>) -> Void)) {
        guard let url = url else {
            print("invalid URL for downloading image")
            return
        }

        if let cachedImage = cacher.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
            return
        }

        imageDownloader.downloadImage(with: url) { result in
            switch result {
            case .success(let image):
                self.cacher.setObject(image, forKey: url.absoluteString as NSString)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
