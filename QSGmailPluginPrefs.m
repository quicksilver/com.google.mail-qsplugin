//
//  QSGmailPluginPrefs.m
//  QSGmailPlugIn
//
//  Created by Patrick Robertson on 15/03/2013.
//
//

#import "QSGmailPluginPrefs.h"
#import "QSGmailMediator.h"
#import <Security/Security.h>

@implementation QSGmailPluginPrefs

-(IBAction)saveInfo:(id)sender {
    NSString *username = usernameField.stringValue;
    NSString *password = passwordField.stringValue;
    if (!username.length || !password.length) {
        QSShowAppNotifWithAttributes(@"QSGmailPluginType", NSLocalizedStringFromTableInBundle(@"Invalid Details",nil,[NSBundle bundleForClass:[self class]],@"Title when invalid login details are entered in the gmail plugin prefs"), NSLocalizedStringFromTableInBundle(@"Invalid Gmail Login Details", nil, [NSBundle bundleForClass:[self class]], @"message when invalid login details are entered in the gmail plugin prefs"));
        NSBeep();
    }
    QSGmailMediator *med = [[QSGmailMediator alloc] init];
    const char *serverName = [[med serverName] UTF8String];
    const char *userchar = [username UTF8String];
    const char *passchar = [password UTF8String];
    
    OSStatus status = SecKeychainAddInternetPassword(NULL, strlen(serverName), serverName, 0, NULL, strlen(userchar), userchar, 0, "", 0, kSecProtocolTypeSMTP, kSecAuthenticationTypeDefault, strlen(passchar), (void *)passchar, NULL);
    
    if (status != noErr) {
        NSString *err = (NSString*)SecCopyErrorMessageString(status, NULL);
        QSShowAppNotifWithAttributes(@"QSGmailPluginType", NSLocalizedStringFromTableInBundle(@"Keychain Error",nil,[NSBundle bundleForClass:[self class]],@"Title when there was an error creating the keychain entry"), err);
    } else {
        [sender setEnabled:NO];
        [sender setStringValue:NSLocalizedStringFromTableInBundle(@"Saved!", nil, [NSBundle bundleForClass:[self class]], @"text on the save button in the gmail prefs when the keychain entry is stored")];
    }
    [med release];
    
}

@end
