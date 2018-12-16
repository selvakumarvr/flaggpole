<?php
require_once 'DB.php';
require_once 'simplepie.inc.php';
require_once 'Bitly.php';
require_once 'Twitter.php';

abstract class RssBot
{
  public $DEBUG = false;
	public $zip;
	public $source;
	protected $bitly;
	protected $cacheDuration = 0; // still does HTTP conditional GET
	protected $maxLength = 140;
	protected $oldnessThreshold = 30; // 30 days
	const DATE_FORMAT = 'Y-m-d H:i:s';
	
	// these functions must be defined in the child class
	abstract function rssUrl($zip);
	abstract function getMessage($item);
	
	public function __construct($source)
	{
		$this->source = $source;
	  $this->bitly = new Bitly();	
	}
	
	public function zips()
	{
	  $zips = array('50021','50263','60625');
	  return $zips;
	}
	
	function crawl($zip)
	{
		$this->zip = $zip;
		$last_crawl = $this->lastCrawl($this->source['id'], $zip);
		//$last_crawl = strtotime('2009-12-01');
		echo "last crawl: ".date(self::DATE_FORMAT,$last_crawl)."\n";
		$rss_url = $this->rssUrl($zip);
		$items = $this->parseRss($rss_url);
		
		// process each RSS item
		$message_count = 0;
		foreach($items as $item) {
			
			// check if the item is new or old
			if($this->isNewItem($item)) {
			  $msg = $this->getMessage($item, true);
			  $this->enqueueMessage($msg, $item['uid']);
			  //echo (Twitter::post($msg))? "Posted to Twitter\n" : "NOT posted to Twitter\n";
			  $message_count++;
			  echo "NEW ";
		  }
		  else {
		    $msg = $this->getMessage($item,false);
		    echo "OLD ";
		  }
		  
		  $msg_length = strlen($msg);
		  echo $item['uid'] . ' ' . date(self::DATE_FORMAT, strtotime($item['date'])) . "\n$msg_length $msg\n";
			echo "\n";
		}
		// record crawl
		$this->recordCrawl($message_count);
	}
	
	function isNewItem($item)
	{
	  $item_date = strtotime($item['date']);
	  $days_threshold = $this->oldnessThreshold * 24 * 60 * 60;
	  $olderThanThreshold = (time() - $item_date) > $days_threshold;
	  return ($this->itemExists($item) || $olderThanThreshold) ? false : true;
	}
	
	function itemExists($item)
	{
	  $params = array('source_id' => $this->source['id'], 'uid' => $item['uid']);
	  $where = 'source_id = :source_id AND uid = :uid';
	  return DB::rowExists('zip_messages', $where, $params);
	}
	
	function parseRss($rss_url)
	{
		$feed = new SimplePie();
		$feed->set_feed_url($rss_url);
		$feed->set_cache_duration($this->cacheDuration);
		$cache_location = dirname(__FILE__) . '/cache';
		$feed->set_cache_location($cache_location);
		$feed->set_stupidly_fast(true);
		$feed->set_timeout(5);
		$feed->set_useragent('Flaggpole.com Bot '.SIMPLEPIE_USERAGENT);
		$feed->init();
		
		$feed->handle_content_type();
		$msgs = array();
		foreach ($feed->get_items() as $item) {
			$msg = array();
			$msg['link'] = $item->get_link();
			$msg['title'] = $item->get_title();
			$msg['description'] = $item->get_description();
			$msg['author'] = $item->get_author()->email;
			$msg['date'] = $item->get_date();
			$msg['uid'] = $item->get_id(true); // get 32-character md5 hash unique ID
			$msgs[] = $msg;
		}
		return $msgs;
	}
	
  function enqueueMessage($msg, $uid)
  {
    if($this->DEBUG) return; // Do not enqueue message if in DEBUG mode
    $message['source_id'] = $this->source['id'];
    $message['zip'] = $this->zip;
    $message['content'] = $msg;
    $message['created_at'] = date(self::DATE_FORMAT);
    $message['updated_at'] = date(self::DATE_FORMAT);
    $message['uid'] = $uid; 
    DB::insert('zip_messages', $message);
  }

  function recordCrawl($cnt)
  {
    $crawl['source_id'] = $this->source['id'];
    $crawl['zip'] = $this->zip;
    $crawl['message_count'] = $cnt;
    $crawl['created_at'] = date(self::DATE_FORMAT);
    $crawl['updated_at'] = date(self::DATE_FORMAT);
    DB::insertOnDuplicateUpdate('crawls', $crawl, array('message_count','updated_at'));
	echo "CRAWL ".$this->arrayString($crawl)."\n\n";
  }

  function lastCrawl($source_id, $zip)
  {
    $sql = 'SELECT updated_at FROM crawls WHERE source_id = :source_id AND zip = :zip ORDER BY created_at DESC LIMIT 1';
    $params['source_id'] = $source_id;
    $params['zip'] = $zip;
    $last_crawl = DB::getOne($sql, $params);
    return strtotime($last_crawl);
  }

	function stripAnchor($url)
	{
		list($url, $anchor) = explode('#', $url);
		return $url; 
	}
	
	function shortenField($item, $field)
	{
      $msg = $this->messageStr($item);
	    $excess = $this->excess($msg);
	    if($excess > 0) $item[$field] = substr($item['title'],0,-$excess);
		  return $item;
	}
	
	function excess($msg)
	{
	  $msg_length = strlen($msg);
		return $msg_length - $this->maxLength;
	}
	
	function arrayString($a)
	{
		$str = '';
		foreach($a as $key=>$val) {
			$str .= "$key: $val, ";
		}
		return $str;
	}
}
