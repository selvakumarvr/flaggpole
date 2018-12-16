<?php

class Twitter
{
	private static function getPassword($zip)
	{
	  return sha1('petey' . $zip);
	}
	
	public static function zipPost($zip, $status)
	{
	  $username = $zip;
	  $password = self::getPassword($zip);
	  //$username = 'ejunkertest';
	  //$password = 'f1aggp01e';
	  return self::post($username, $password, $status);
	}
	
	public static function post($username, $password, $status)
	{
		$status = urlencode(stripslashes(urldecode($status)));
		if ($status) {
			$tweetUrl = 'http://www.twitter.com/statuses/update.xml';
			
			$curl = curl_init();
			curl_setopt($curl, CURLOPT_URL, "$tweetUrl");
			curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 2);
			curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($curl, CURLOPT_POST, 1);
			curl_setopt($curl, CURLOPT_POSTFIELDS, "status=$status");
			curl_setopt($curl, CURLOPT_USERPWD, "$username:$password");
			
			//curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
			//curl_setopt($curl, CURLOPT_HEADER, 0);
			
			$result = curl_exec($curl);
			$resultArray = curl_getinfo($curl);
			curl_close($curl);
					
			return ($resultArray['http_code'] == 200);
		}
	}
}
