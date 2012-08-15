//
//  loadDatabaseViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-06.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "loadDatabaseViewController.h"

@implementation loadDatabaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _linkTextField.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLinkTextField:nil];
    [self setStatusTextField:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loadButton:(id)sender
{
    NSString *link = _linkTextField.text;
    [_db readURL:link];
    [_parent update];
    if ([_db.species count])
    {
        NSString *field = [NSString stringWithFormat:@"Read %d species",[_db.species count]];
        [self.statusTextField setText:field];
    }
    else
    {
        [self.statusTextField setText:@"Could not read database"];

    }
}

- (IBAction)mergeButton:(id)sender {
}

- (IBAction)saveButton:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_db.json forKey:@"database"];
}

- (IBAction)exportButton:(id)sender {
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"editDatabaseSegue"])
    {
        [segue.destinationViewController setDb:_db];
        [segue.destinationViewController setParent:_parent];
        [segue.destinationViewController setFunctionNames:_functionNames];
    }
}
@end
