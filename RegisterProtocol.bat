::
:: MIT License
:: 
:: Copyright (c) 2021 Pharap (@Pharap)
:: 
:: Permission is hereby granted, free of charge, to any person obtaining a copy
:: of this software and associated documentation files (the "Software"), to deal
:: in the Software without restriction, including without limitation the rights
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
:: copies of the Software, and to permit persons to whom the Software is
:: furnished to do so, subject to the following conditions:
:: 
:: The above copyright notice and this permission notice shall be included in all
:: copies or substantial portions of the Software.
:: 
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
:: SOFTWARE.
::

::
:: Associates 'URL Protocols' with a file handler
::
:: NOTE: Requires admin permissions
::

:: Begin a local scope
:: (Automatically ends when script ends)
@SETLOCAL

:: Check for a protocol
@IF [%1] == [] (
@ECHO "URL protocol not specified"
@GOTO :PrintUsage
)

:: Set %protocol%
@SET protocol=%1

:: Check for a protocol handler
@IF [%2] == [] (
@ECHO "Protocol handler not specified"
@GOTO :PrintUsage
)

:: Determine whether or not the protocol handler exists
@IF NOT EXIST "%~f2" (
@ECHO "The specified protocol handler does not exist"
@ECHO "Provided value:" %~f2
@GOTO :eof
)

:: Set %handler%
@SET handler=%~f2

:: Make sure %force% is empty at first
@SET force=

:: Determine whether the user specified the 'force' option
@IF NOT [%3] == [] @IF "%3" == "/F" @SET force=/F

:: Edit the registry
@REG ADD HKCR\%protocol% %force%
@REG ADD HKCR\%protocol% /VE /D "URL:%protocol% protocol" %force%
@REG ADD HKCR\%protocol% /V "URL Protocol" %force%
@REG ADD HKCR\%protocol%\shell\Open\Command %force%
@REG ADD HKCR\%protocol%\shell\Open\Command /VE /D "\"%handler%\" \"%%1\"" %force%
@GOTO :eof

:PrintUsage
@ECHO "Usage: RegisterProtocol <protocol> <handler> [/F]"
@ECHO "<protocol> - A valid protocol name"
@ECHO "<handler> - A valid protocol handler, a path to an executable file"
@ECHO "[/F] - The option '/F' suppresses any overwrite prompts"
@GOTO :eof