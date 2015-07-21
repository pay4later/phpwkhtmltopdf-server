<?php

class UserException extends RuntimeException
{
    /**
     * @var string
     */
    private $statusText;

    public function __construct($message = 'An error occurred',
                                $code = '500 Internal Server Error',
                                Exception $previous = null)
    {
        list($statusCode, $statusText) = $this->parseCode($code);
        parent::__construct($message, $statusCode, $previous);
        $this->statusText = $statusText;
    }

    /**
     * @see Exception::getCode()
     * @return int
     */
    public function getStatusCode()
    {
        return $this->getCode();
    }

    /**
     * @return string
     */
    public function getStatusText()
    {
        return $this->statusText;
    }

    private function parseCode($code)
    {
        if (($off = strpos($code, ' ')) !== false) {
            $text = substr($code, $off + 1);
            $code = substr($code, 0, $off);
        } else {
            $text = '';
        }

        return [$code, $text];
    }
}