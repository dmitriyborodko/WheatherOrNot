import Foundation
import PromiseKit

protocol ImageService {

    func fetchImage(with url: URL) -> Promise<UIImage>
}

class DefaultImageService: ImageService {

    func fetchImage(with url: URL) -> Promise<UIImage> {
        return firstly {
            URLSession.shared.dataTask(.promise, with: url)
        }.compactMap {
            UIImage(data: $0.data)
        }
    }
}
