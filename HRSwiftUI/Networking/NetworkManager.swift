import Foundation

final class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func requestDecodable<T: Decodable>(
        _ endpoint: Endpoint,
        as type: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let request = endpoint.urlRequest else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                let offline = OfflineRequest(
                    url: request.url?.absoluteString ?? "",
                    method: request.httpMethod ?? "POST",
                    headers: request.allHTTPHeaderFields ?? [:],
                    body: request.httpBody.flatMap { String(data: $0, encoding: .utf8) },
                    timestamp: Date(),
                    actionType: endpoint.actionType
                )
                OfflineURLStorage.shared.save(offline)
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }

            guard let data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }

    func uploadMultipart<T: Decodable>(
        url: URL,
        params: [String: Any],
        fileData: Data?,
        fileName: String?,
        fileMimeType: String?,
        fileFieldName: String = "attachment",
        as type: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func appendField(name: String, value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        for (key, value) in params {
            if let dict = value as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dict),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                appendField(name: key, value: jsonString)
            } else if let array = value as? [Any],
                      let jsonData = try? JSONSerialization.data(withJSONObject: array),
                      let jsonString = String(data: jsonData, encoding: .utf8) {
                appendField(name: key, value: jsonString)
            } else {
                appendField(name: key, value: "\(value)")
            }
        }

        if let fileData, let fileName, let fileMimeType {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fileFieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(fileMimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }

            guard let data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }

    func resendOfflineRequests(completion: @escaping () -> Void = {}) {
        let requests = OfflineURLStorage.shared.fetch()
        guard !requests.isEmpty else {
            completion()
            return
        }

        let group = DispatchGroup()

        for req in requests {
            group.enter()
            guard let url = URL(string: req.url) else {
                group.leave()
                continue
            }

            var request = URLRequest(url: url)
            request.httpMethod = req.method
            request.allHTTPHeaderFields = req.headers
            request.httpBody = req.body?.data(using: .utf8)

            URLSession.shared.dataTask(with: request) { _, _, error in
                if error == nil {
                    OfflineURLStorage.shared.remove([req])
                }
                group.leave()
            }.resume()
        }

        group.notify(queue: .main) {
            completion()
        }
    }
}
