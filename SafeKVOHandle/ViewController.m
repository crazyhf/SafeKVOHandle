//
//  ViewController.m
//  SafeKVOHandle
//
//  Created by crazylhf on 15/10/8.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import "ViewController.h"

#import "NSObject+KVOHelper.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL testKVOKey;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self onAddSaveKVOHandleAction:nil];
}


#pragma mark - ui action

- (IBAction)onTestSaveKVOHandleAction:(id)sender
{
    self.testKVOKey = !self.testKVOKey;
}

- (IBAction)onAddSaveKVOHandleAction:(id)sender
{
    [self.hfKVOHandler addObserveKeyPath:@"testKVOKey" reactiveSelector:@selector(onTestKVOKeyChanged:) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld];
}

- (IBAction)onRemoveSaveKVOHandleAction:(id)sender
{
    [self.hfKVOHandler removeObserveKeyPath:@"testKVOKey"];
}


#pragma mark - KVO handle

- (void)onTestKVOKeyChanged:(NSDictionary *)change
{
    [[[UIAlertView alloc] initWithTitle:@"testKVOKey changed" message:change.description delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
}


#pragma mark - memory handle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
