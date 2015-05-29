//
//  DetailViewController.h
//  FindMyNearestPizzaPlace
//
//  Created by Alex Santorineos on 5/28/15.
//  Copyright (c) 2015 madApperz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController


@property NSMutableArray* pizzaShops;
@property CLLocationManager *locationManager;

@end
