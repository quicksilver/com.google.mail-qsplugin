//
//  QSGmailPluginPrefs.h
//  QSGmailPlugIn
//
//  Created by Patrick Robertson on 15/03/2013.
//
//

#import <Cocoa/Cocoa.h>

@interface QSGmailPluginPrefs : QSPreferencePane {
    IBOutlet NSTextField *usernameField;
    IBOutlet NSSecureTextField *passwordField;
}

-(IBAction)openGmailHelp:(id)sender;
-(IBAction)saveInfo:(id)sender;

@end
