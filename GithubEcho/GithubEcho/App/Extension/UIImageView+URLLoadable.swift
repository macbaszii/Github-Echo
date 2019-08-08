import UIKit

extension UIImageView {
    func setImage(with url: URL?) {
        let imageCacher = ImageCacheImplementation()
        imageCacher.cacheImage(with: url) { result in
            switch result {
            case .success(let image):
                self.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
