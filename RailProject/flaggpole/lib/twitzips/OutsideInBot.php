<?php
require_once 'RssBot.php';

class OutsideInBot extends RssBot
{
  function rssUrl($zip)
	{
		return "http://outside.in/$zip.rss";
	}
	
	function getMessage($item, $shortenUrl = true)
	{
		$shortenUrl = !$this->DEBUG; // Do not shorten URL if in DEBUG mode
	  
	  // format the message
		$item['via'] =  'http://outside.in/' . $this->zip;
		
		$rss_link = $item['link'];
		$link = "http://bit.ly/??????";
		//$link = $rss_link;
		if($shortenUrl) {
		  $bitly = Bitly::getInstance();
		  $link = $bitly->getShort($rss_link);
	  }
		$item['link'] = $link;
		
		// shorten some fields if necessary
    $item = $this->shorten($item);
    $msg = $this->messageStr($item);
		return $msg;
	}
	
	function shorten($item)
	{
    $item = $this->shortenField($item,'title');
    //$item = $this->shortenField($item,'author');
    return $item;
	}
	
	function messageStr($item)
	{
	  return trim("{$item['link']} {$item['title']}, {$item['author']} via {$item['via']}"); 
	}
	
	private function getOriginURL($link)
	{
		$url_parts = parse_url($link);
		parse_str(urldecode($url_parts['query']), $query_parts);
		$url = $query_parts['url'];
		return $url;
	}
}
