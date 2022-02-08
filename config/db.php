<?php

use yii\db\Connection;

$host = getenv("POSTGRES_HOST");
$dbName = getenv("DB_NAME");
$user = getenv("POSTGRES_USER");
$password = getenv("POSTGRES_PASSWORD");

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
