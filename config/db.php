<?php

use yii\db\Connection;

$source = getenv("DB_SOURCE");
$host = getenv("DB_HOST");
$dbName = getenv("DB_NAME");
$user = getenv("DB_USER");
$password = getenv("DB_PASSWORD");

$db = [
    "class" => Connection::class,
    "dsn" => "pgsql:host=$host;dbname=$dbName",
    "username" => $user,
    "password" => $password,
    "charset" => "utf8",
];

if (getenv('ENV') === 'prod') {
    $db = array_merge($db, [
        // Schema cache options (for production environment)
        'enableSchemaCache' => true,
        'schemaCacheDuration' => 60,
        'schemaCache' => 'cache',
    ]);
}
return $db;
