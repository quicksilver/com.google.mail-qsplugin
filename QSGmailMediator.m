//
//  QSGmailMediator.m
//  QSGmailPlugIn
//
//  Created by Rob McBroom on 2013/03/15.
//
//

#import "QSGmailMediator.h"

@implementation QSGmailMediator

- (NSString *)serverName {
    return @"smtp.gmail.com";
}

- (NSDictionary *)smtpServerDetails
{
    NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [self serverName], QSMailMediatorServer,
                                    @"465", QSMailMediatorPort,
                                    @"YES", QSMailMediatorTLS,
                                    @"YES", QSMailMediatorAuthenticate,
                                    
                                    nil];
    NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:@"QSGmailUsername"];
    UInt32 passLen = 0;
    void *password = nil;
    OSStatus status = SecKeychainFindInternetPassword(NULL, (UInt32)[[self serverName] length], [[self serverName] UTF8String], 0, NULL, (UInt32)[user length], [user UTF8String], 0, NULL, 0, kSecProtocolTypeSMTP, kSecAuthenticationTypeDefault, &passLen, &password, NULL);
    if (status == noErr) {
        NSString *smtpPassword = [NSString stringWithCString:password encoding:[NSString defaultCStringEncoding]];
        SecKeychainItemFreeContent(NULL, password);
        if ([smtpPassword length] > passLen) {
            // trim extra characters from the buffer
            smtpPassword = [smtpPassword substringToIndex:passLen];
        }
        [details setObject:user forKey:QSMailMediatorUsername];
        [details setObject:smtpPassword forKey:QSMailMediatorPassword];
    }
    return details;
}

- (NSImage *)iconForAction:(NSString *)actionID
{
    return [QSResourceManager imageNamed:@"com.google.GmailNotifier"];
}

- (void)sendEmailTo:(NSArray *)addresses
               from:(NSString *)sender
            subject:(NSString *)subject
               body:(NSString *)body
        attachments:(NSArray *)pathArray
            sendNow:(BOOL)sendNow
{
	NSMutableString *mailURL = [NSMutableString stringWithString:@"https://mail.google.com/mail/?view=cm"];
	[mailURL appendFormat:@"&fs=1"]; // fullscreen
	[mailURL appendFormat:@"&tf=1"]; // tearoff
	
	[mailURL appendFormat:@"&to=%@", [addresses componentsJoinedByString:@", "]];
    //	[mailURL appendFormat:@"&cc = %@",];
    //	[mailURL appendFormat:@"&bcc = %@",];
	[mailURL appendFormat:@"&su=%@", [subject URLEncoding]];
	[mailURL appendFormat:@"&body=%@", [body URLEncoding]];
    
    
    //Just append any of these to the GMail Compose Email URL above.
    //Email To: "to"
    //Usage: "%26to%3Dmike%40rabidsquirrel%2Enet"
    //CC: "cc"
    //Usage: "%26cc%3D"
    //	Comma Delimited list of emails
    //BCC: "bcc"
    //Usage: "%26bcc%3D"
    //	Comma Delimited list of emails
    //	Subject Line: "su"
    //Usage: "%26su%3DYour%2520Subject%2520Line"
    //Body: "body"
    //Usage: "%26body%3DBlahblah"
    //	https://mail.google.com/mail/?dest = https://mail.google.com/mail?view = cm&fs = 1&tf = 1&to = zero@blacktree.com&su = blah&body = blah
    
#if 0
    id cont = [[NSClassFromString(@"QSSimpleWebWindowController") alloc] initWithWindow:nil];
    [cont openURL:[NSURL URLWithString:trueURL]];
    [[cont window] makeKeyAndOrderFront:nil];
#endif
    NSURL *url = [NSURL URLWithString:mailURL];
    if (!url) {
        NSLog(@"Error opening URL %@", mailURL);
    }
    [[NSWorkspace sharedWorkspace] openURL:url];
}

@end
