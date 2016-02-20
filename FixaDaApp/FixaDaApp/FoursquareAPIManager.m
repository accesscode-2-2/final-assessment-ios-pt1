//
//  FoursquareAPIManager.m
//  FixaDaApp
//
//  Created by Michael Kavouras on 2/15/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import "FoursquareAPIManager.h"
#import <AFNetworking/AFNetworking.h>
#import "VenueObject.h"

#define kFoursquareAPIClientID     @"GWKJBVWFYBJQ02T3TRBB4VBL24AIO4TCMJCGIQ5ADKVKJXGP"
#define kFoursquareAPIClientSecret @"2WMEZCDQNKNB5XAE5F4BY1VHBK1HITYRU1JEVCOAD2QRLXDJ"

@interface FoursquareAPIManager ()

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
           completion:(void(^)(NSMutableArray *data))completion
{
    NSMutableArray *locations = [[NSMutableArray alloc] init]; // alloc init array
    
    NSString *baseURL = @"https://api.foursquare.com/v2/venues/search";
    NSString *url = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&v=20160215&ll=%f,%f&query=%@", baseURL, kFoursquareAPIClientID, kFoursquareAPIClientSecret, location.coordinate.latitude, location.coordinate.longitude, query];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject)
    {
        
        if (responseObject != nil) {
            
        NSArray *venuesMy = [[responseObject objectForKey:@"response"] objectForKey:@"venues"];
            
            for (NSDictionary *venue in venuesMy) {
                
                NSString *venueName = [venue objectForKey:@"name"]; // pull info from dictionary
                NSString *lat = [[venue objectForKey:@"location"]objectForKey:@"lat"];
                NSString *lng = [[venue objectForKey:@"location"]objectForKey:@"lng"];
                
                double latDbl = lat.doubleValue; // convert to doubles
                double lngDbl = lng.doubleValue;
                
                VenueObject *venue = [[VenueObject alloc] init]; // initialize storage object
                
                venue.name = venueName; // save in object
                venue.lat = latDbl;
                venue.lng = lngDbl;
                
                [locations addObject:venue]; // add to object
                
            }
            completion(locations);
        
        }
    
    } failure:^(NSURLSessionTask *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
