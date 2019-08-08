import Foundation

typealias NetworkConnectionResult = (data: Data, urlResponse: HTTPURLResponse)

protocol NetworkConnector {
    func request(url: URL,
                 completion: @escaping ((Result<NetworkConnectionResult>) -> Void)) -> URLSessionDataTask
}

final class NetworkConnectorImplementation: NetworkConnector {
    func request(url: URL,
                 completion: @escaping ((Result<NetworkConnectionResult>) -> Void)) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(
            with: url)
        { (data, urlResponse, error) in

            DispatchQueue.main.async {
                guard error == nil else {
                    guard let unwrappedError = error else { return }
                    completion(.failure(unwrappedError))
                    return
                }

                guard let unwrappedData = data,
                    let unwrappedURLResponse = urlResponse as? HTTPURLResponse else {
                        return
                }

                let result = (unwrappedData, unwrappedURLResponse)
                completion(.success(result))
            }
        }

        return dataTask
    }
}
