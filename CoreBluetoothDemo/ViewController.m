//
//  ViewController.m
//  CoreBluetoothDemo
//
//  Created by Jone on 07/12/2016.
//  Copyright © 2016 Jone. All rights reserved.
//

#import "ViewController.h"
#import "CoreBluetoothManager.h"

@interface ViewController ()
@property (nonatomic, strong) CoreBluetoothManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CoreBluetoothManager *manager = [[CoreBluetoothManager alloc] init];
    _manager = manager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
