//
//  BleTransportConfiguration.swift
//  BleTransport
//
//  Created by Dante Puglisi on 5/10/22.
//

import Foundation
import CoreBluetooth

@objc
public class BleTransportConfiguration: NSObject {
    let devices: [Device]
    
    var connectedDevice: Device?
    
    public init(devices: [Device]) {
        self.devices = devices
    }
    
    static func defaultConfig() -> BleTransportConfiguration {
        BleTransportConfiguration(devices: Device.allCases)
    }
    
    public func serviceMatching(serviceUUID: CBUUID) -> Device? {
        return devices.first(where: { configService in serviceUUID == configService.service.service.uuid })
    }
}

@objc
public class BleService: NSObject {
    
    let service: ServiceIdentifier
    
    let notify: CharacteristicIdentifier
    let writeWithResponse: CharacteristicIdentifier
    let writeWithoutResponse: CharacteristicIdentifier
    
    public init(serviceUUID: String, notifyUUID: String, writeWithResponseUUID: String, writeWithoutResponseUUID: String) {
        let service = ServiceIdentifier(uuid: serviceUUID)
        self.notify = CharacteristicIdentifier(uuid: notifyUUID, service: service)
        self.writeWithResponse = CharacteristicIdentifier(uuid: writeWithResponseUUID, service: service)
        self.writeWithoutResponse = CharacteristicIdentifier(uuid: writeWithoutResponseUUID, service: service)
        self.service = service
    }
    
    func writeCharacteristic(canWriteWithoutResponse: Bool) -> CharacteristicIdentifier {
        return canWriteWithoutResponse ? writeWithoutResponse : writeWithResponse
    }
    
    static func == (lhs: BleService, rhs: BleService) -> Bool {
        return lhs.service.uuid == rhs.service.uuid
    }
}

public enum Device: Int, CaseIterable {
    case nanox, flex, gen5, stax
    
    var name: String {
        switch self {
        case .nanox:
            return "Ledger Nano X"
        case .flex:
            return "Ledger Flex"
        case .gen5:
            return "Ledger Nano Gen5"
        case .stax:
            return "Stax"
        }
    }
    
    var service: BleService {
        switch self {
        case .nanox:
            return BleService(serviceUUID: "13d63400-2c97-0004-0000-4c6564676572",
                                  notifyUUID: "13d63400-2c97-0004-0001-4c6564676572",
                                  writeWithResponseUUID: "13d63400-2c97-0004-0002-4c6564676572",
                                  writeWithoutResponseUUID: "13d63400-2c97-0004-0003-4c6564676572")
        case .flex:
            return BleService(serviceUUID: "13d63400-2c97-3004-0000-4c6564676572",
                              notifyUUID: "13d63400-2c97-3004-0001-4c6564676572",
                              writeWithResponseUUID: "13d63400-2c97-3004-0002-4c6564676572",
                              writeWithoutResponseUUID: "13d63400-2c97-3004-0003-4c6564676572")
        case .gen5:
            return BleService(serviceUUID: "13d63400-2c97-8004-0000-4c6564676572",
                                  notifyUUID: "13d63400-2c97-8004-0001-4c6564676572",
                                  writeWithResponseUUID: "13d63400-2c97-8004-0002-4c6564676572",
                                  writeWithoutResponseUUID: "13d63400-2c97-8004-0003-4c6564676572")
        case .stax:
            return BleService(serviceUUID: "13d63400-2c97-6004-0000-4c6564676572",
                              notifyUUID: "13d63400-2c97-6004-0001-4c6564676572",
                              writeWithResponseUUID: "13d63400-2c97-6004-0002-4c6564676572",
                              writeWithoutResponseUUID: "13d63400-2c97-6004-0003-4c6564676572")
        }
    }
    
}
