//
//  CoreBluetoothManager.h
//  DMRentEnterprise
//
//  Created by Jone on 01/12/2016.
//  Copyright © 2016 Jone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;
@interface CoreBluetoothManager : NSObject

@property (nonatomic, strong, readonly) NSArray<CBPeripheral *> *peripherals;


@end
