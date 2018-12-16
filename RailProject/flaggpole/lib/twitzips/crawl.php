<?php
// TODO make sure sources table names match class filenames
$sources = array(
  array('id' => '1', 'name' => 'OutsideIn'),
//  array('id' => '2', 'name' => 'EveryBlock'),
);

foreach($sources as $source) {
  $botName = $source['name'].'Bot';
  require_once $botName.'.php';
  $bot = new $botName($source);
  
  //$zips = array('50322');
  $zips = $bot->zips();
  foreach($zips as $zip) {
    $bot->crawl($zip);
  }
}
