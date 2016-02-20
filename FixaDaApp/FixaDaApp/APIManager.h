//
//  APIManager.h
//  FixaDaApp
//
//  Created by Shena Yoshida on 2/20/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

// public method:
+ (void)GETRequestWithURL:(NSURL *)URL // + makes it a class method, we don't have to alloc init it!
        completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock;

// completionHandler = block
@end
