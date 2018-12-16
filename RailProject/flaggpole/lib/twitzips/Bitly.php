<?php

class Bitly
{
	private $login = 'ejunker';
	private $apiKey= 'R_dd76420153c38cb8bc00c942ab40f4b9';
	private $bitlyCache = array();
	private static $instance;
	
	public static function getInstance()
  {
    if(!self::$instance) {
      self::$instance = new Bitly();
    }
    return self::$instance;
  }
	
	public function getShort($url) {
	    $url = urlencode($url);
	    if($this->cached($url)) {
			$bitlyurl = $this->getCache($url);
			//echo "CACHE HIT\n";
	    }
	    else {
	    	// TODO need to urlencode url?
		    $bitlyurl = file_get_contents("http://api.bit.ly/shorten?version=2.0.1&longUrl=".$url."&login=".$this->login."&apiKey=".$this->apiKey);
		    $bitlycontent = json_decode($bitlyurl, true);
            $bitlyerror = $bitlycontent["errorCode"];
		    
            // Don't compare sent URL with returned URL
            // Bitly removes invalid poritions of URLs
            // The camparison might fail even though the URLs are the "same"
            $results = current($bitlycontent['results']);
		    
		    $bitlyurl = ($bitlyerror == 0)? $results["shortUrl"] : $url;
            //$bitlyurl = ($bitlyerror == 0)? $results["shortUrl"] : 'ERROR';
			$this->cache($url, $bitlyurl);
			//echo "CACHE MISS\n";
	    }
	    return $bitlyurl;
	}
	
	private function cached($url)
	{
		$key = $this->getKey($url);
		return isset($this->bitlyCache[$key]);
	}
	
	private function getCache($url)
	{
		$key = $this->getKey($url);
		return $this->bitlyCache[$key];
	}
	
	private function cache($url, $bitlyUrl)
	{
		$key = $this->getKey($url);
		$this->bitlyCache[$key] = $bitlyUrl;
	}
	
	private function getKey($url)
	{
		return $url;
	}
}
