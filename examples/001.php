<?php

$_POST = [
    'pages' => [
        [
            'content' => '<!doctype html><meta charset="utf-8"><title>1</title><p>1</p>',
            'options' => [
                'zoom' => 10
            ]
        ],
        [
            'uri' => 'https://twitter.com/sfnet_ops',
            'options' => [
                'background'
            ]
        ],
        'https://twitter.com/sfnet_ops'
    ],
    'options' => [
        'margin-top'    => 0,
        'margin-right'  => 0,
        'margin-bottom' => 0,
        'margin-left'   => 0,
        'print-media-type'
    ]
];

require_once __DIR__ . '/../public/index.php';