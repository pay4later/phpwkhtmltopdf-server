<?php

use GuzzleHttp\Client;
use PHPUnit\Framework\TestCase;

class EndToEndTest extends TestCase
{
    private $baseUrl;

    /** @var Client */
    private $client;

    public function setUp()
    {
        $this->baseUrl = getenv('BASE_URL') ?: 'http://app/';

        $this->client = new Client([
            'base_uri' => $this->baseUrl,
        ]);
    }

    public function testItAcceptsValidHttpRequestAndRendersAnyPdf()
    {
        $requestBody = [
            'pages' => [
                [
                    'content' => <<<HTML
<!doctype html>
<html>
    <head>
        <title>Title 1</title>
        <meta charset="utf-8"/>
    </head>
    <body>
        <h1>Header 1</h1>
        <p>Paragraph 1</p>
    </body>
</html>
HTML
                    ,
                    'options' => [
                        'zoom' => 1.5
                    ]
                ],
                [
                    'content' => <<<HTML
<!doctype html>
<html>
    <head>
        <title>Title 2</title>
        <meta charset="utf-8"/>
    </head>
    <body>
        <h1>Header 2</h1>
        <p>Paragraph 2</p>
    </body>
</html>
HTML
                    ,
                    'options' => [
                        'background',
                    ],
                ],
            ],
            'options' => [
                'margin-top'    => 0,
                'margin-right'  => 0,
                'margin-bottom' => 0,
                'margin-left'   => 0,
                'print-media-type'
            ]
        ];

        $response = $this->client->request('POST', '/', [
            'form_params' => $requestBody,
        ]);

        $content = $response->getBody()->getContents();

        file_put_contents(__DIR__ . '/results/example.pdf', $response->getBody()->getContents());

        $this->assertEquals('%PDF', substr($content, 0, 4));
    }
}
