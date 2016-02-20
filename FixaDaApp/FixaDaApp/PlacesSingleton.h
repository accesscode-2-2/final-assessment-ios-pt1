//
//  PinManager.h
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/2/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlacesSingleton : NSObject

@property (nonatomic,strong) NSMutableArray *locations;

+ (PlacesSingleton *) sharedManager;


@end
