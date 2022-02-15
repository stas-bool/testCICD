<?php

namespace unit;

use Codeception\Test\Unit;

class FailTest extends Unit
{
    protected \UnitTester $tester;

    // tests
    public function testFail(): void
    {
        self::fail('Тестируем падение тестов 2');
//        self::assertTrue(true);
    }
}