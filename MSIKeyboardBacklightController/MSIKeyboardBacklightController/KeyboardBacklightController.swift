//
//  KeyboardBacklightController.swift
//  MSIKeyboardBacklightController
//
//  Created by Rostyslav Dovhaliuk on 8/2/15.
//  Copyright © 2015 Rostyslav Dovhaliuk. All rights reserved.
//

import Foundation
import IOKit
import IOKit.hid

enum USBError: ErrorType {
    case USBOperation(String)
}

class KeyboardBacklightController {
    private let HIDManager: IOHIDManager = {
        let manager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDManagerOptionNone.rawValue).takeRetainedValue()
        let matchingDictionary = [kIOHIDProductIDKey : 0xFF00, kIOHIDVendorIDKey : 0x1770]
        IOHIDManagerSetDeviceMatching(manager, matchingDictionary as CFDictionary)
        return manager
    }()
    
    func setConfiguration(configuration: BacklightModeConfiguration) throws {
        do {
            let hidDevice = try aquireUSBDevice()
            for report in configuration.featureReports {
                var result: IOReturn = kIOReturnSuccess
                report.withUnsafeBufferPointer{ pointer -> Void in
                    result = IOHIDDeviceSetReport(hidDevice, kIOHIDReportTypeFeature, CFIndex(pointer[0]), pointer.baseAddress, pointer.count)
                }
                guard result == kIOReturnSuccess else {
                    throw USBError.USBOperation("Data transfer with USB device failed.")
                }
            }
            try releaseUSBDevice(hidDevice)
        } catch {
            throw error
        }
    }
    
    private func aquireUSBDevice() throws -> IOHIDDevice {
        guard IOHIDManagerOpen(HIDManager, kIOHIDManagerOptionNone.rawValue) == kIOReturnSuccess else {
            throw USBError.USBOperation("Can't open an instance of IOHIDManager")
        }
        let matchingDevices = IOHIDManagerCopyDevices(HIDManager).takeRetainedValue() as NSSet
        guard let object = matchingDevices.anyObject() where object is IOHIDDevice else {
            throw USBError.USBOperation("No matching device was found. Please check whether USB device with idProduct = 0xFF00 and idVendor = 0x1770 is available.")
        }
        let hidDevice = object as! IOHIDDevice
        guard IOHIDDeviceOpen(hidDevice, IOOptionBits(kIOHIDOptionsTypeSeizeDevice)) == kIOReturnSuccess else {
            throw USBError.USBOperation("Can't open an instance of IOHIDDevice. Please check whether USB device with idProduct = 0xFF00 and idVendor = 0x1770 isn't acquired by other process.")
        }
        return hidDevice
    }
    
    private func releaseUSBDevice(device: IOHIDDevice) throws {
        defer { IOHIDManagerClose(HIDManager, kIOHIDManagerOptionNone.rawValue) }
        guard IOHIDDeviceClose(device, IOOptionBits(kIOHIDOptionsTypeNone)) == kIOReturnSuccess else {
            throw USBError.USBOperation("Can't close an instance of IOHIDDevice.")
        }
    }
}
