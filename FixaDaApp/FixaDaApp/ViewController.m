//
//  ViewController.m
//  FixaDaApp
//
//  Created by Michael Kavouras on 2/14/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "FoursquareAPIManager.h"
#import <CoreLocation/CoreLocation.h>
#import "APIResults.h"

@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
MKMapViewDelegate
>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL foundPlaces;

@property (nonatomic) NSArray *venues;
@property (nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *searchResults;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.locationManager requestAlwaysAuthorization];
}


# pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeepBoopCellIdentifier"];
        
    APIResults *currentResult = self.searchResults[indexPath.row];
    cell.textLabel.text = currentResult.name;

    
    return cell;
}

# pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.foundPlaces) {
        self.foundPlaces = YES;
        
        [self zoomToLocation:userLocation.location];
        [self fetchVenuesAtLocation:userLocation.location];
    }
}

- (void)zoomToLocation:(CLLocation *)location
{
    MKCoordinateSpan span = MKCoordinateSpanMake(.9,.9);
    CLLocationCoordinate2D coordinate = location.coordinate;
    MKCoordinateRegion region = {coordinate, span};
    MKCoordinateRegion regionThatFits = [self.mapView regionThatFits:region];
    [self.mapView setRegion:regionThatFits animated:YES];
}

- (void)fetchVenuesAtLocation:(CLLocation *)location
{
        __weak typeof(self) weakSelf = self;
        [FoursquareAPIManager findSomething:@"music"
                                 atLocation:(__bridge CLLocationCoordinate2D *)(location)
                                 completion:^(NSArray *data){
                                     
                                     weakSelf.venues = data;
                                     [weakSelf.tableView reloadData];
                                     [weakSelf showPins];
                                     
                                     
                                     self.searchResults = [[NSMutableArray alloc] init];
                                     
                                     for (NSDictionary *venue in self.venues) {
                                         NSString *name = venue[@"name"];
//                                         [self.venues arrayByAddingObject:self.name];
                                     
                                         APIResults *searchObject = [[APIResults alloc] init];
                                         searchObject.name = name;
                                         [self.searchResults addObject:searchObject];

                                     }
                                     
                                     
                                 }];
}

- (void)showPins
{
    [self.mapView addAnnotations:self.mapView.annotations];
    
    for (NSDictionary *venue in self.venues) {
        double lat = [venue[@"location"][@"lat"] doubleValue];
        double lng = [venue[@"location"][@"lng"] doubleValue];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(lat, lng);
        [self.mapView addAnnotation:point];
    }
}

@end
