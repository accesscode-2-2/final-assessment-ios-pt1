//
//  FoursquareAPIManager.m
//  FixaDaApp
//
//  Created by Michael Kavouras on 2/15/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import "FoursquareAPIManager.h"
#import <AFNetworking/AFNetworking.h>
#import "APIResults.h"

#define kFoursquareAPIClientID     @"GWKJBVWFYBJQ02T3TRBB4VBL24AIO4TCMJCGIQ5ADKVKJXGP"
#define kFoursquareAPIClientSecret @"2WMEZCDQNKNB5XAE5F4BY1VHBK1HITYRU1JEVCOAD2QRLXDJ"

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
    
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    NSString *baseURL = @"https://api.foursquare.com/v2/venues/search";
    NSString *url = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&v=20160215&ll=%f,%f&query=%@", baseURL, kFoursquareAPIClientID, kFoursquareAPIClientSecret, location.coordinate.latitude, location.coordinate.longitude, query];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject)
     
     {
         
         if (responseObject != nil) {
             
             NSArray *venues = [[responseObject objectForKey:@"response"]objectForKey:@"venues"];
             
             
             for (NSDictionary *venue in venues) {
                 NSString *name = [venue objectForKey:@"name"];
                 NSString *lat = [[venue objectForKey:@"location"]objectForKey:@"lat"];
                 NSString *lng = [[venue objectForKey:@"location"]objectForKey:@"lng"];
                 
                 double latVal = lat.doubleValue;
                 double lngVal = lng.doubleValue;
                 
                 APIResults *venue = [[APIResults alloc] init];
                 
                 venue.name = name;
                 venue.lat = latVal;
                 venue.lng = lngVal;
                 NSLog(@"%@",name);
                 
                 [locations addObject:venue];
             }
             completion(locations);
             
         }
         
         
     } failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}

@end
