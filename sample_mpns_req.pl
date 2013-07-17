#!/usr/bin/perl -w
  
use strict;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Headers;


# Sample request for microsoft push notification service
# print SendNotification('http://db3.notify.live.net/throttledthirdparty/01.00/AHEHNbRDjdk3Rr6DCPlxYnbVAgAVAAADAQAAnAQUZm52OjIzOEQ1NDKDRkI5MEVFMEQ','test',5,3,0,0);
#
# For comment mashkov@gmail.com 



sub SendNotification {
        my ($urlSending,$textForSend,$count,$delay,$messageId,$target) = @_;

		#Make Headers 
		my $apiHeader = SetUpHeaders($delay,$messageId,$target);
		
		#Make  xml for req.
		my $apiRequest = GetApiRequest($count,$textForSend);
		#POST
		my $apiPostRequest = HTTP::Request->new("POST",$urlSending,$apiHeader,$apiRequest);
 
		my $apiUserAgent = LWP::UserAgent->new;
		my $apiResponse = $apiUserAgent->request($apiPostRequest);
		#return RESPONSE
		if (!$apiResponse->is_error) {
			 return $apiResponse->content;
		}
		else {
			 return $apiResponse->error_as_HTML;
		}
}

sub GetApiRequest {
    my ($count,$title) = @_;
	my $apiRequest ="<?xml version=\"1.0\" encoding=\"utf-8\"?>" .
				"<wp:Notification xmlns:wp=\"WPNotification\">" .
					"<wp:Tile>" .
						"<wp:Count>$count</wp:Count>" .
						"<wp:Title>".$title."</wp:Title>" .
					"</wp:Tile>" .
				"</wp:Notification>";
	return $apiRequest;
}			  

sub SetUpHeaders {
    my ($delay,$messageId,$target) = @_;
	my $apiHeader = HTTP::Headers->new;
	$apiHeader->push_header('Content-Type' => 'application/xml');
	$apiHeader->push_header('Accept' => 'application/*');
	$apiHeader->push_header('X-NotificationClass' => $delay);
	$apiHeader->push_header('X-MessageID' => $messageId);
	$apiHeader->push_header('X-WindowsPhone-Target' => $target);
  return $apiHeader;
}
