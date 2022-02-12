<?php

/**
 * @var $this yii\web\View
 * @var $list Test[]
 */

use app\models\Test;

$this->title = 'List';

?>

<div class="site-test">
    <table>
        <?php foreach ($list as $value): ?>
        <tr>
            <td><?= $value->id ?></td>
            <td><?= $value->value ?></td>
        </tr>
        <?php endforeach; ?>
    </table>
</div>
