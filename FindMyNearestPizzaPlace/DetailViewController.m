//
//  DetailViewController.m
//  FindMyNearestPizzaPlace
//
//  Created by Alex Santorineos on 5/28/15.
//  Copyright (c) 2015 madApperz. All rights reserved.
//

#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import "Pizza.h"

@interface DetailViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *pizzaAnnotation;
@property NSObject <MKAnnotation> *pizzAnnotation;
@property MKPolyline *polyLine;



@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation =YES;





    self.mapView.delegate = self;
    for (Pizza *pizza in self.pizzaShops) {
        self.pizzaAnnotation = [MKPointAnnotation new];
        self.pizzaAnnotation.coordinate = CLLocationCoordinate2DMake(pizza.placemark.location.coordinate.latitude, pizza.placemark.location.coordinate.longitude);
        self.pizzaAnnotation.title = pizza.name;

        [self.mapView addAnnotation:self.pizzaAnnotation];
    }




//    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(41.8369, -87.6847);
//
//    MKCoordinateSpan span;
//    span.latitudeDelta =  0.1;
//    span.longitudeDelta = 0.1;
//
//    MKCoordinateRegion region;
//    region.center = centerCoordinate;
//    region.span = span;
//
//    [self.mapView setRegion:region animated:YES];






    NSLog(@"%lu",(unsigned long)self.pizzaShops.count);
}



-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{


    CLLocationCoordinate2D centerCoordinate = userLocation.coordinate;

    MKCoordinateSpan span;
    span.latitudeDelta =  1;
    span.longitudeDelta = 1;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = span;

    [self.mapView setRegion:region animated:YES];

}



-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    if ([annotation isEqual:mapView.userLocation]) {
        return nil;
    }
    else{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        return pin;}

    
    
    //*
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;

//_polyLine = [MKPolyline polylineWithCoordinates:(CLLocationCoordinate2D *) count:<#(NSUInteger)#>]

}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {

    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}


//- (void) drawRoute:(NSArray *) path
//{
//    NSInteger numberOfSteps = path.count;
//
//    CLLocationCoordinate2D coordinates[numberOfSteps];
//    for (NSInteger index = 0; index < numberOfSteps; index++) {
//        CLLocation *location = [path objectAtIndex:index];
//        CLLocationCoordinate2D coordinate = location.coordinate;
//
//        coordinates[index] = coordinate;
//    }
//
//    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
//    [self.mapView addOverlay:polyLine];
//    
//    
//}
//
//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
//    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
//    polylineView.strokeColor = [UIColor redColor];
//    polylineView.lineWidth = 1.0;
//
//    return polylineView;
//}
@end
