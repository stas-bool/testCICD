<?php

namespace app\tests\unit;

class FailTest extends \Codeception\Test\Unit
{
    protected \UnitTester $tester;

    // tests
    public function testFail(): void
    {
        self::fail('Тестируем падение тестов');
    }
}