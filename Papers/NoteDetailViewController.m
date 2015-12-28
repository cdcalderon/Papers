//
//  NoteDetailViewController.m
//  Papers
//
//  Created by Lorena Calderon on 12/28/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "DataStore.h"

@interface NoteDetailViewController ()

@end

@implementation NoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DataStore *dataStore = [DataStore sharedDataStore];

    NSLog(@"%@", [self.managedObject valueForKey:@"title"] );
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
