//
//  loadDatabaseViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-06.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "loadDatabaseViewController.h"


@interface loadDatabaseViewController ()
@end

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
    if (_link != nil)
    {
        _linkTextField.text = _link;
    }
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
    NSArray *species = [_db.json allKeys];

    if (![species count])
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
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!!! This will erase the old database." message:@"Load anyway" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Load", nil];
    
        alert.delegate = self;
        [alert show];
    }
}

- (IBAction)mergeButton:(id)sender {
    // load new database
    NSString *link = _linkTextField.text;
    database *tmpDB = [[database alloc] init];
    [tmpDB readURL:link];
    if ([tmpDB.species count])
    {
        NSString *field = [NSString stringWithFormat:@"Merging %d species",[tmpDB.species count]];
        [self.statusTextField setText:field];
        NSArray *speciesToAdd = tmpDB.species;
        
        for (int i=0; i<[speciesToAdd count]; i++)
        {
            
            // check if species exist
            bool speciesExist = NO;
            NSString *speciesNameToAdd = [speciesToAdd objectAtIndex:i];
            for (int j=0; j<[_db.species count]; j++)
            {
                NSString *name = [_db.species objectAtIndex:j];
                if ([speciesNameToAdd isEqualToString:name])
                {
                    speciesExist = YES;
                    // if it exists, check for every property and add them
                    NSMutableDictionary *propertiesDictToAdd = [tmpDB.json objectForKey:name];
                    NSArray *propertiesToAdd = [propertiesDictToAdd allKeys];
                    NSMutableDictionary *propertiesDict = [_db.json objectForKey:name];
                    NSArray *existingProperties = [propertiesDict allKeys];
                    for (int ii=0; ii<[propertiesToAdd count]; ii++)
                    {
                        bool propertyExist = NO;
                        NSString *propertyNameToAdd = [propertiesToAdd objectAtIndex:ii];
                        for (int jj=0; jj<[existingProperties count]; jj++)
                        {
                            NSString *propertyName = [existingProperties objectAtIndex:jj];
                            if ([propertyNameToAdd isEqualToString:propertyName])
                            {
                                propertyExist = YES;
                                // if property exists, append _i++ to name and add it.
                                int add = 1;
                                bool nameIsValid = NO;
                                while (!nameIsValid)
                                {
                                    add++;
                                    NSString *newPropNameToAdd = [NSString stringWithFormat:@"%@_%d",propertyNameToAdd, add];
                                    nameIsValid = YES;
                                    for (int n=0; n<[existingProperties count]; n++)
                                    {
                                        NSString *pName = [existingProperties objectAtIndex:n];

                                        if ([newPropNameToAdd isEqualToString:pName])
                                        {
                                            nameIsValid = NO;
                                        }
                                    }

                                }
                                NSString *newPropNameToAdd = [NSString stringWithFormat:@"%@_%d",propertyNameToAdd, add];
                                [propertiesDict setObject:[propertiesDictToAdd objectForKey:propertyNameToAdd] forKey:newPropNameToAdd];
                            }
                        }
                        if (!propertyExist)
                        {
                            [propertiesDict setObject:[propertiesDictToAdd objectForKey:propertyNameToAdd] forKey:propertyNameToAdd];
                        }
                    }
                }
            }
            
            // add species if it doesnt
            if (!speciesExist)
            {
                [_db.json setObject:[tmpDB.json objectForKey:speciesNameToAdd] forKey:speciesNameToAdd];
            }
        }
        [_parent update];
 
    }
    else
    {
        [self.statusTextField setText:@"Could not read database"];
    }
    
}

- (IBAction)saveButton:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_db.json forKey:@"database"];
    [defaults setObject:_linkTextField.text forKey:@"link"];
    [defaults synchronize];
    [self.statusTextField setText:@"Database saved"];
    [_parent setLink:_linkTextField.text];
}

- (IBAction)exportButton:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            NSString *msg = [NSString stringWithFormat:@"%@",_db.json];
            NSData *att = [msg dataUsingEncoding:[NSString defaultCStringEncoding]];
            //[mailer setMessageBody:msg isHTML:NO];
            [mailer setMessageBody:@"sent from propertyView" isHTML:NO];
            [mailer setSubject:@"database.json"];
            [mailer addAttachmentData:att mimeType:@"text/plain" fileName:@"database.json"];
            [self presentModalViewController:mailer animated:YES];
        }
        else
        {
            // error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't send mail" message:@"device does not support email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        // error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't send mail" message:@"device does not support email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)linkFieldEnter:(id)sender
{
    _link = _linkTextField.text;
    [_parent setLink:_link];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField
{
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
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
}

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
    if (error)
    {
        [self.statusTextField setText:[error localizedDescription]];
    }
    else
    {
        [self.statusTextField setText:@"mail sent"];
    }
}

@end
