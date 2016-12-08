//
//  CoreBluetoothManager.m
//  DMRentEnterprise
//
//  Created by Jone on 01/12/2016.
//  Copyright © 2016 Jone. All rights reserved.
//

#import "CoreBluetoothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface CoreBluetoothManager()<CBCentralManagerDelegate, CBPeripheralDelegate,CBPeripheralManagerDelegate> {
    NSMutableArray *_peripheralsList;
}

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *currentPeripheral;

@end

@implementation CoreBluetoothManager

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    _centralManager = centralManager;

    return self;
}

#pragma mark - CBCentralManagerDelegate

// 在 cetral 的状态变为 CBManagerStatePoweredOn 的时候开始扫描
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
        [_centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (!peripheral.name) return; // Ingore name is nil peripheral.
    if (![_peripheralsList containsObject:peripheral]) {
        [_peripheralsList addObject:peripheral];
        _peripherals = _peripheralsList.copy;
    }
    
    // 在某个地方停止扫描并连接至周边设备
    [_centralManager stopScan];
    [_centralManager connectPeripheral:peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
 
    peripheral.delegate = self;
    
//     Client to do discover services method...
     CBUUID *seriveUUID = [CBUUID UUIDWithString:@"d2009d00-6000-1000-8000-000000000000"];
     [peripheral discoverServices:@[seriveUUID]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
}


#pragma mark - CBPeripheralDelegate

// 发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    NSArray *services = peripheral.services;
    if (services) {
        CBService *service = services[0];
        CBUUID *writeUUID = [CBUUID UUIDWithString:@"D2009D01-6000-1000-8000-000000000000"];
        CBUUID *notifyUUID = [CBUUID UUIDWithString:@"D2009D02-6000-1000-8000-000000000000"];
        __unused CBUUID *unusedUUID = [CBUUID UUIDWithString:@"D2009D02-6000-1000-8000-000000000001"];
        
        [peripheral discoverCharacteristics:@[writeUUID, notifyUUID] forService:service]; // 发现服务
    }
}

// 发现特性值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    if (!error) {
        NSArray *characteristicArray = service.characteristics;
        CBCharacteristic *writeCharacteristic = characteristicArray[0];
        CBCharacteristic *notifyCharacteristic = characteristicArray[1];
        
        // 通知使能， `YES` enable notification only, `NO` disabel notifications and indications
        [peripheral setNotifyValue:YES forCharacteristic:notifyCharacteristic];
        [peripheral writeValue:[NSData data] forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
    } else {
        NSLog(@"Discover charactertics Error : %@", error);
    }
}

// 写入成功
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (!error) {
        NSLog(@"Write Success");
    } else {
        NSLog(@"WriteVale Error = %@", error);
    }
}

// 回复
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"update value error: %@", error);
    } else {
         __unused NSData *responseData = characteristic.value;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    
}
@end
