import CommonCrypto
import Foundation

enum AESEncryptionUtils {
    private static let encryptionKey = Data(base64Encoded: "/uHLGNxBtGI9WutDnPfiNoGNiKjdaNivKAoVRu1t/ks=")!
    private static let initializationVector = Data(base64Encoded: "IH+8WIrwsLOZNhUfRk6GKg==")!

    static func encryptData(_ object: Any) throws -> String {
        let plainText = String(describing: object)
        guard let dataToEncrypt = plainText.data(using: .utf8) else {
            throw NSError(domain: "AESEncryptionUtils", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode plaintext"])
        }
        let encryptedData = try crypt(data: dataToEncrypt, operation: CCOperation(kCCEncrypt))
        return encryptedData.base64EncodedString()
    }

    static func decryptData(_ encryptedInput: String) throws -> String {
        guard let decodedData = Data(base64Encoded: encryptedInput) else {
            throw NSError(domain: "AESEncryptionUtils", code: -1, userInfo: [NSLocalizedDescriptionKey: "Base64 decode failed"])
        }
        let decryptedData = try crypt(data: decodedData, operation: CCOperation(kCCDecrypt))
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw NSError(domain: "AESEncryptionUtils", code: -1, userInfo: [NSLocalizedDescriptionKey: "UTF8 decode failed"])
        }
        return decryptedString
    }

    private static func crypt(data: Data, operation: CCOperation) throws -> Data {
        let keyLength = encryptionKey.count
        guard [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256].contains(keyLength) else {
            throw NSError(domain: "AESEncryptionUtils", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid AES key length"])
        }

        var outputLength = Int(0)
        let outputCapacity = data.count + kCCBlockSizeAES128
        var outputData = Data(count: outputCapacity)

        let status = outputData.withUnsafeMutableBytes { outputBytes in
            data.withUnsafeBytes { dataBytes in
                encryptionKey.withUnsafeBytes { keyBytes in
                    initializationVector.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            operation,
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress,
                            keyLength,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress,
                            data.count,
                            outputBytes.baseAddress,
                            outputCapacity,
                            &outputLength
                        )
                    }
                }
            }
        }

        guard status == kCCSuccess else {
            throw NSError(domain: "AESEncryptionUtils", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "CCCrypt failed"])
        }

        outputData.removeSubrange(outputLength..<outputData.count)
        return outputData
    }
}
