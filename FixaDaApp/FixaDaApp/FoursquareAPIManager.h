//
//  FoursquareAPIManager.h
//  FixaDaApp
//
//  Created by Michael Kavouras on 2/15/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FoursquareAPIManager : NSObject

+ (void)findSomething:(NSString *)query
           atLocation:(CLLocation *)location
           completion:(void(^)(id data))completion;

@end
