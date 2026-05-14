import Combine
import Foundation

final class EmployeeUnlinkTimeOffViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var apiMessage: String?
    @Published var success = false

    func unlinkDraftLeave(token: String, leaveId: Int) {
        isLoading = true
        apiMessage = nil
        success = false

        let endpoint = API.unlinkDraftAnnualLeaves(token: token, action: "unlink_draft_annual_leaves", leaveId: leaveId)
        NetworkManager.shared.requestDecodable(endpoint, as: UnlinkDraftLeaveResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false

                switch result {
                case let .success(response):
                    self.success = response.result.status == "success"
                    self.apiMessage = response.result.message
                case let .failure(error):
                    self.success = false
                    self.apiMessage = String(describing: error)
                }
            }
        }
    }
}
