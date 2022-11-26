//
//  AppDelegate.swift
//  CustomProtocolTest
//
//  Created by David Albert on 11/26/22.
//

import Cocoa
import Network

import os


@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let parameters = NWParameters(customIPProtocolNumber: 89)
        let endpoint = NWEndpoint.hostPort(host: "127.0.0.1", port: 0)
        let connection = NWConnection(to: endpoint, using: parameters)

        connection.stateUpdateHandler = { state in
            print(state)

        }
        connection.send(content: Data([1, 2, 3, 4]), completion: .idempotent)

        connection.start(queue: .main)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

