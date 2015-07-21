<?php

use DI\Container;
use DI\ContainerBuilder;
use Zend\Config\Config;

require_once __DIR__ . '/../vendor/autoload.php';

/**
 * Set up the application in an anonymous function to avoid defining global variables
 * @return Container
 */
return call_user_func(function () {

    $config = new Config(require __DIR__ . '/../config/global.php');

    if (file_exists(__DIR__ . '/../config/local.php')) {
        $temp = new Config(require __DIR__ . '/../config/local.php');
        $config->merge($temp);
        unset($temp);
    }

    $builder = new ContainerBuilder();
    $builder->addDefinitions(array('config' => $config));
    $builder->addDefinitions($config['factories']->toArray());

    return $builder->build();

});