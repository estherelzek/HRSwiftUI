import Foundation

final class LocationUpdateViewModel {
    func checkLocationUpdates(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let employeeToken = UserDefaults.standard.employeeToken else {
            completion(.failure(APIError.requestFailed("No employee token")))
            return
        }

        let endpoint = API.checkLocationUpdates(token: employeeToken)
        NetworkManager.shared.requestDecodable(endpoint, as: LocationUpdateResponse.self) { result in
            switch result {
            case let .success(response):
                guard let data = response.result else {
                    completion(.failure(APIError.requestFailed("No result in response")))
                    return
                }

                if data.changed {
                    self.updateEmployeeLocations(locations: data.companyLocations, allowedIDs: data.allowedLocationsIds)
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func updateEmployeeLocations(locations: [Company]?, allowedIDs: [Int]?) {
        if let locations {
            let branches: [AllowedLocation] = locations.compactMap { company in
                guard let address = company.address,
                      let id = address.id,
                      let latitude = address.latitude,
                      let longitude = address.longitude,
                      let allowedDistance = address.allowedDistance
                else { return nil }

                return AllowedLocation(id: id, latitude: latitude, longitude: longitude, allowedDistance: allowedDistance)
            }

            UserDefaults.standard.companyBranches = branches
        }

        if let allowedIDs {
            UserDefaults.standard.allowedBranchIDs = allowedIDs
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("LocationsUpdated"), object: nil)
        }
    }
}
