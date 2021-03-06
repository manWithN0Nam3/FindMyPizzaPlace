//
//  ViewController.m
//  FindMyNearestPizzaPlace
//
//  Created by Alex Santorineos on 5/28/15.
//  Copyright (c) 2015 madApperz. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Pizza.h"
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property Pizza *pizza;
@property CLLocationManager *locationManager;
@property NSMutableArray *pizzaShops;
@property  MKMapItem *mapItemP;
@property NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];

}

#pragma mark delegateMethod
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

    NSLog(@"%@",error);

}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    for (CLLocation *location in locations) {
        if (location.verticalAccuracy <1000 && location.horizontalAccuracy <1000) {
            [self reverseGeoCode:location];
            NSLog(@"%@",location);
            [self.locationManager stopUpdatingLocation];
        }
    }


}

#pragma mark helperMethods
-(void)reverseGeoCode:(CLLocation *)location{

    CLGeocoder *geoCoder = [CLGeocoder new];

    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {

        CLPlacemark *placemark = placemarks.firstObject;
        [self findCoffeeShopsNearLoccation:placemark.location];

 //        NSLog(@"%@",placemark);
    }];

}


-(void)findCoffeeShopsNearLoccation:(CLLocation *)location{

    

    MKLocalSearchRequest *request = [MKLocalSearchRequest new];

    request.naturalLanguageQuery = @"pizza";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(2, 2));


    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {

        NSArray *mapItems = response.mapItems;
//        Pizza *pizza = [Pizza new];
        MKMapItem *mapIt = [MKMapItem new];

        NSMutableArray *mutableArray = [NSMutableArray new];
        for (int i = 0; i<=3; i++) {




//            pizza.milesDifference = mileD;

//            pizza = [mapItems objectAtIndex:i];
            mapIt = [mapItems objectAtIndex:i];

            [mutableArray addObject:mapIt];

            self.pizzaShops = [NSMutableArray arrayWithArray:mutableArray];
        }

        [self.tableView reloadData];

//        [self getDirections:self.mapItemP];


    }];
}


-(void)getDirections:(MKMapItem *)destinationItem {


    if (_segmentedControl.selectedSegmentIndex == 0) {
        MKDirectionsRequest *request = [MKDirectionsRequest new];
        request.source = [MKMapItem mapItemForCurrentLocation];
        request.destination = destinationItem;


        request.transportType = MKDirectionsTransportTypeAutomobile;

        MKDirections *directions = [[MKDirections alloc]initWithRequest:request];


        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            //        NSArray *routes = response.routes.firstObject;
            MKRoute *route = response.routes.firstObject;

            int x = 1;
            NSMutableString *coolString = [NSMutableString string];

            for (MKRouteStep *step in route.steps) {
                //                        NSLog(@"%@",step.instructions);
                [coolString appendFormat:@"%d: %@\n", x,step.instructions];
                x++;
            }
            self.textView.text = coolString;
        }];

    }
    else if (_segmentedControl.selectedSegmentIndex ==1){

        MKDirectionsRequest *request = [MKDirectionsRequest new];
        request.source = [MKMapItem mapItemForCurrentLocation];
        request.destination = destinationItem;


        request.transportType = MKDirectionsTransportTypeWalking;

        MKDirections *directions = [[MKDirections alloc]initWithRequest:request];


        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            //        NSArray *routes = response.routes.firstObject;
            MKRoute *route = response.routes.firstObject;

            int x = 1;
            NSMutableString *coolString = [NSMutableString string];

            for (MKRouteStep *step in route.steps) {
                //                        NSLog(@"%@",step.instructions);
                [coolString appendFormat:@"%d: %@\n", x,step.instructions];
                x++;
            }
            self.textView.text = coolString;
        }];


    }
    }


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    Pizza *pizza =[self.pizzaShops objectAtIndex:indexPath.row];


    self.indexPath = indexPath;
    [self getDirections:[self.pizzaShops objectAtIndex:self.indexPath.row]];


}
#pragma mark IBAction

- (IBAction)onSegmentedControllPressed:(UISegmentedControl *)sender {

    if (sender.selectedSegmentIndex == 0) {
        //    [request setTransportType:MKDirectionsTransportTypeAutomobile];

        //is driving

    }else if (sender.selectedSegmentIndex ==1){

//is walking

    }
}

#pragma mark tableViewDataSourceMethod
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return self.pizzaShops.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    MKMapItem *mapItem = [self.pizzaShops objectAtIndex:indexPath.row];
//    Pizza *pizza =[self.pizzaShops objectAtIndex:indexPath.row];


 CLLocationDistance distanceInMeters = [mapItem.placemark.location distanceFromLocation:self.locationManager.location];
    float mileD = distanceInMeters / 1609.34;

    cell.textLabel.text = mapItem.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f miles",mileD];

//    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    return cell;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *dVc = segue.destinationViewController;

    dVc.pizzaShops = self.pizzaShops;

}

@end
