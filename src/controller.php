<?php

use mikehaertl\wkhtmlto\Pdf;

class controller
{
    /**
     * @var Pdf
     */
    protected $pdf;

    public function __construct(Pdf $pdf)
    {
        $this->pdf = $pdf;
    }

    public function dispatch()
    {
        $options = isset($_POST['options']) ? array_map('trim', $_POST['options']) : [];
        $this->pdf->setOptions($options);
        $pageCount = 0;
        $pages = isset($_POST['pages']) ? (array)$_POST['pages'] : [];

        foreach ($pages as $page) {
            $contentVerified = false;

            if (is_string($page)) {
                if (preg_match(Pdf::REGEX_HTML, $page)) {
                    $contentVerified = true;
                    $page = ['content' => $page];
                } else {
                    $page = ['uri' => $page];
                }
            }

            $options = isset($page['options']) ? array_map('trim', $page['options']) : [];

            if (!empty($page['content']) && !$contentVerified) {
                $page['content'] = trim($page['content']);
                if (!preg_match(Pdf::REGEX_HTML, $page['content'])) {
                    $this->abort('pages[#].content does not contain an <html tag');
                }

                $this->assertNotFile($page['content']);
                $this->pdf->addPage($page['content'], $options);
                $pageCount++;
            }

            if (!empty($page['uri'])) {
                if (($uri = filter_var($page['uri'], FILTER_VALIDATE_URL)) === false) {
                    $this->abort('pages[#].uri is not a valid url');
                }

                $this->assertNotFile($uri);
                $this->pdf->addPage($uri, $options);
                $pageCount++;
            }
        }

        if (!$pageCount) {
            $this->abort('Missing pages[#].{uri,content}');
        }

        if (!$this->pdf->send('download.pdf')) {
            $this->abort($this->pdf->getError(), '500 Internal Server Error');
        }
    }

    private function abort($message, $httpStatus = '400 Bad Request')
    {
        throw new UserException($message, $httpStatus);
    }

    private function assertNotFile($filename)
    {
        if (file_exists($filename)) {
            $this->abort('Forbidden');
        }
    }
}
