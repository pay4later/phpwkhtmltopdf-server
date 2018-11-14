<?php

use DI\Container;

try {
    /** @var Container $container */
    $container = require __DIR__ . '/../src/bootstrap.php';
    /** @var Controller $controller */
    $controller = $container->make('controller');
    $controller->dispatch();
} catch (Exception $e) {
    if (PHP_SAPI !== 'cli') {
        header($e instanceof UserException
            ? "HTTP/1.1 {$e->getStatusCode()} {$e->getStatusText()}"
            : 'HTTP/1.1 500 Internal Server Error');

        $message = htmlspecialchars($e->getMessage());
    } else {
        $message = $e->getMessage();
    }

    echo $message;
}
