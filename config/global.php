<?php

use DI\Container;

return [
    'wkhtmltopdf' => [
        'binary' => 'wkhtmltopdf'

        /*  The following options are defaults:
            'print-media-type',
            'margin-top'     => 0,
            'margin-right'   => 0,
            'margin-bottom'  => 0,
            'margin-left'    => 0
        */
    ],
    'factories' => [
        'mikehaertl\wkhtmlto\Pdf' => function (Container $c) {
            $options = $c->get('config')->get('wkhtmltopdf')->toArray();
            $pdf = new \mikehaertl\wkhtmlto\Pdf($options);
            return $pdf;
        }
    ]
];
