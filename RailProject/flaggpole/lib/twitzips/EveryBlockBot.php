<?php
require_once 'RssBot.php';

class EveryBlockBot extends RssBot
{
	function rssUrl($zip)
	{
		return "http://seattle.everyblock.com/rss/locations/zipcodes/98101/";
	}
	
	function getMessage($item)
	{
		// format the message
		// TODO check length and truncate
		$rss_link = $item['link'];
		$rss_link = $this->stripAnchor($rss_link);
		//$link = "http://bit.ly/??????";
		//$link = $this->bitly->getShort($rss_link);
		$link = $rss_link;
		$item['link'] = $link;
		
		$parts = parse_url($rss_link);
		$item['via'] =  $parts['scheme'].'://'.$parts['host'];
		
		$msg = "{$item['link']} {$item['title']} via {$item['via']}";
		return $msg;
	}
}