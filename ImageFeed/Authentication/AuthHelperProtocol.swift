import Foundation

protocol AuthHelperProtocol {
    var authRequest: URLRequest? { get }
    func getCode(from url: URL) -> String?
}
