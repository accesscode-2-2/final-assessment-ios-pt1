//
//  PinManager.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "PlacesSingleton.h"

@implementation PlacesSingleton

@synthesize locations;

+ (PlacesSingleton *) sharedManager{
    static PlacesSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.locations = [[NSMutableArray alloc] init];
    });
    return sharedMyManager;
}

@end
