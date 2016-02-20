//
//  FoursquareAPIManager.h
//  FixaDaApp
//
//  Created by Michael Kavouras on 2/15/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//@protocol VenuePassingDelegate <NSObject> // this doesn't work
//- (void)incomingVenuesFromFoursquare:(NSArray *)venues;
//@end

@interface FoursquareAPIManager : NSObject

//@property (weak, nonatomic) id <VenuePassingDelegate> delegate; 


+ (void)findSomething:(NSString *)query
           atLocation:(CLLocation *)location
           completion:(void(^)(NSMutableArray *data))completion;

@end
