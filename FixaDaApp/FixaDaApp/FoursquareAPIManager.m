//
//  FoursquareAPIManager.m
//  FixaDaApp
//
//  Created by Michael Kavouras on 2/15/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import "FoursquareAPIManager.h"
#import <AFNetworking/AFNetworking.h>

#define kFoursquareAPIClientID     @"GWKJBVWFYBJQ02T3TRBB4VBL24AIO4TCMJCGIQ5ADKVKJXGP"
#define kFoursquareAPIClientSecret @"2WMEZCDQNKNB5XAE5F4BY1VHBK1HITYRU1JEVCOAD2QRLXDJ"

@interface FoursquareAPIManager ()

@property (nonatomic, strong) NSArray *venue; // why can't I call "self" in this class?

@end

@implementation FoursquareAPIManager

/**
 
 https://api.foursquare.com/v2/venues/search
 ?client_id=CLIENT_ID
 &client_secret=CLIENT_SECRET
 &v=20130815
 &ll=40.7,-74
 &query=sushi
 
**/


+ (void)findSomething:(NSString *)query
           atLocation:(CLLocation *)location
           completion:(void(^)(NSArray *data))completion
{
    

    
    NSString *baseURL = @"https://api.foursquare.com/v2/venues/search";
    NSString *url = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&v=20160215&ll=%f,%f&query=%@", baseURL, kFoursquareAPIClientID, kFoursquareAPIClientSecret, location.coordinate.latitude, location.coordinate.longitude, query];
    
//    NSLog(@"url: %@", url);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject)
    {
//        NSLog(@"response object: %@", responseObject);
        
        
        if (responseObject != nil) {
            
        NSArray *venuesMy = [[responseObject objectForKey:@"response"] objectForKey:@"venues"];
        
            // one idea: pass over array with delegate
//          [self.delegate incomingVenuesFromFoursquare:[NSArray venues]];
            // then sort in the next view!
            
            
            // I can access data from the api, no problem!
            NSMutableArray *venueArray = [[NSMutableArray alloc] init];
            NSMutableArray *venueLat = [[NSMutableArray alloc] init];
            NSMutableArray *venueLng = [[NSMutableArray alloc] init];
            
            for (NSDictionary *venue in venuesMy) {
                
                NSString *venueName = [venue objectForKey:@"name"];
                NSString *lat = [[venue objectForKey:@"location"]objectForKey:@"lat"];
                NSString *lng = [[venue objectForKey:@"location"]objectForKey:@"lng"];
                
                [venueArray addObject:venueName];
                [venueLat addObject:lat];
                [venueLng addObject:lng];
                
            }

            NSLog(@"venue: %@", venueArray);
            NSLog(@"lat: %@", venueLat);
            NSLog(@"lng: %@", venueLng); 
        
        }
    
    } failure:^(NSURLSessionTask *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
