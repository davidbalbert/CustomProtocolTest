//
//  AppDelegate.swift
//  CustomProtocolTest
//
//  Created by David Albert on 11/26/22.
//

import Cocoa
import Network

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var window: NSWindow!

    var connection: NWConnection?
    var group: NWConnectionGroup?

    @IBAction func sendPacket(_ sender: Any) {
        let parameters = NWParameters(customIPProtocolNumber: 123)

        let destination = NWEndpoint.hostPort(host: "127.0.0.1", port: 0)
        let connection = NWConnection(to: destination, using: parameters)

        connection.start(queue: .main)
        connection.send(content: Data([1, 2, 3, 4]), completion: .contentProcessed({ error in
            print("error", error)
        }))

        self.connection = connection
    }

    @IBAction func multicastListen(_ sender: Any) {
        guard let allSPFRouters = try? NWMulticastGroup(for: [NWEndpoint.hostPort(host: "224.0.0.5", port: 0)]) else {
            print("Couldn't create NWMulticastGroup")
            return
        }

        let parameters = NWParameters(customIPProtocolNumber: 123)
        let group = NWConnectionGroup(with: allSPFRouters, using: parameters)

        group.setReceiveHandler(maximumMessageSize: 16384, rejectOversizedMessages: true) { (message, content, isComplete) in
            print("received", message, content, isComplete)
        }
        group.stateUpdateHandler = { print("state", $0) }
        group.start(queue: .main)

        self.group = group
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

