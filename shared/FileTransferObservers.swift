/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Manages the observation of the file transfer progress.
*/

import Foundation
import WatchConnectivity

// Manage the observation of file transfers.
//
class FileTransferObservers {
    
    // Hold the observations and file transfers.
    // The system removes KVO automatically after releasing the observations.
    //
    private(set) var fileTransfers = [WCSessionFileTransfer]()
    private var observations = [NSKeyValueObservation]()
    
    // Invalidate all the observations.
    //
    deinit {
        observations.forEach { observation in
            observation.invalidate()
        }
    }
    
    // Observe a file transfer, and hold the observation.
    //
    func observe(_ fileTransfer: WCSessionFileTransfer, handler: @escaping (Progress) -> Void) {
        let observation = fileTransfer.progress.observe(\.fractionCompleted) { progress, _ in
            handler(progress)
        }
        observations.append(observation)
        fileTransfers.append(fileTransfer)
    }
    
    // Un-observe a file transfer, and invalidate the observation.
    //
    func unobserve(_ fileTransfer: WCSessionFileTransfer) {
        guard let index = fileTransfers.firstIndex(of: fileTransfer) else { return }
        let observation = observations.remove(at: index)
        observation.invalidate()
        fileTransfers.remove(at: index)
    }
}

