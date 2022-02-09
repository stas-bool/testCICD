<?php

/**
 * @var $this yii\web\View
 * @var $branch string
 */

use yii\helpers\Html;

$this->title = $branch;

?>

<div class="site-test">
    <h1><?= 'Branch: '.Html::encode($this->title) ?></h1>
</div>
