<?php
require 'DB.php';
require 'Twitter.php';

$messages = DB::getAll('SELECT id,zip,content FROM zip_messages WHERE tweeted = 0');
foreach($messages as $msg) {
  extract($msg);
  $posted = Twitter::zipPost($zip, $content);
  if($posted) markTweeted($id);
  $postStr = ($posted)? 'POSTED': 'NOT POSTED';
  echo "$postStr $id $content\n";
}

function markTweeted($id)
{
  $row['id'] = $id;
  $row['tweeted'] = 1;
  $row['updated_at'] = date(DB::DATE_FORMAT);
  return DB::update('zip_messages','id', $row);    
}

