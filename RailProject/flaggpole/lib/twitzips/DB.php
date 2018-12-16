<?php
// http://www.sitepoint.com/forums/showthread.php?t=587985#

class DB
{
  private static $instance;
  const DATE_FORMAT = 'Y-m-d H:i:s';
  
  private function __construct() {}
  private function __clone() {}
  
  public static function getConnection($cfg = array())
  {
    if(!self::$instance) {
      extract($cfg);
      try {
        self::$instance = new PDO("mysql:host={$hostname};dbname={$database}",$username,$password,array());
      }
      catch (PDOException $e) {
        echo 'Connection failed: ' . $e->getMessage();
      }
      self::$instance->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING);
    }
    return self::$instance;
  }
  
  public static function insert($table, $row)
  {
      $names = array();
      $values = array();
      foreach ($row as $name => $value) {
          $names[] = $name;
          $values[] = ':'.$name;
      }
      $names = implode(', ', $names);
      $values = implode(', ', $values);
      $sql = "INSERT INTO $table ($names) VALUES ($values)";
      self::query($sql, $row);
      
      $db = self::getConnection();
      $id = $db->lastInsertId();
      return $id;
  }
  
  public static function insertOnDuplicateUpdate($table, $row, $update)
  {
      $names = array();
      $values = array();
      foreach ($row as $name => $value) {
          $names[] = $name;
          $values[] = ':'.$name;
      }
      $names = implode(', ', $names);
      $values = implode(', ', $values);
      
      $updates = array();
      foreach($update as $u) {
      	$updates[] = "$u = VALUES($u)";
      }
      $update_sql = implode(', ', $updates);
      
      $sql = "INSERT INTO crawls ($names) VALUES ($values) ON DUPLICATE KEY UPDATE $update_sql";
      self::query($sql, $row);
      
      $db = self::getConnection();
      $id = $db->lastInsertId();
      return $id;
  }
  
  function update($table, $pk, $params)
  {    
    $pairs = array();
    foreach(array_keys($params) as $name) {
    	$pairs[] = "$name = :" . $name;
    }
    $pairs = implode(', ', $pairs);
    
    $sql = "UPDATE $table SET $pairs WHERE $pk = :" . $pk;
    $statement = self::query($sql, $params);
    return $statement->rowCount();
  }
  
  private static function query($sql, $params)
  {
    $db = self::getConnection();
    $statement = $db->prepare($sql);
    $statement->execute($params);
    return $statement;
  }
  
  public static function getRow($sql, $params = array())
  {
    $statement = self::query($sql, $params);
    $row = $statement->fetch(PDO::FETCH_ASSOC);
    $statement->closeCursor();
    return $row;
  }
  
  public static function getCol($sql, $col = 0, array $params = array())
  {
    $statement = self::query($sql, $params);
    $ret = array();
    while ($row = $statement->fetch(PDO::FETCH_NUM)) {
      $ret[] = $row[$col];
    }
 
    $statement->closeCursor();
    return $ret;
  }
  
  public static function getAll($sql, $params = array())
  {
    $statement = self::query($sql, $params);
    $rows = $statement->fetchAll(PDO::FETCH_ASSOC);
    $statement->closeCursor();
    return $rows;
  }
  
  public static function getOne($sql, $params = array())
  {
    $statement = self::query($sql, $params);
    $row = $statement->fetch(PDO::FETCH_NUM);
    $statement->closeCursor();
    return $row[0];
  }
  
  public static function rowExists($table, $where, $params = array())
  {
    $sql = "SELECT * from $table WHERE $where LIMIT 1";
    $statement = self::query($sql, $params);
    return $statement->rowCount() > 0;
  }
  
  public static function deleteWhere($table, $where, $params = array()){
    $sql = "DELETE FROM $table WHERE $where";
    $statement = self::query($sql, $params);
    return $statement->rowCount();
  }
}

$db_config =  array(
                'hostname' => 'localhost',
                'database' => 'flaggpole_development',
                'username' => 'flaggpole',
                'password' => 'f1aggp01e'
              );
DB::getConnection($db_config);
