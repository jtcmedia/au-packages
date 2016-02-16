. ../au.ps1

$releases = 'http://www.exactaudiocopy.de/en/index.php/weitere-seiten/download-from-alternative-servers-2'

function au_SearchReplace {
    @{".\tools\chocolateyInstall.ps1" = @{ "(^[$]url32\s*=\s*)('.*')" = "`$1'$($Latest.URL)'" }}
}

function au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    $re  = "eac.*\.exe"
    $url = $download_page.links | ? href -match $re | select -First 1 -expand href
    if (!$url) { throw "Can't match any url using '$re'" }


    $re      = "^[\d.]+$"
    $version  = $url -split '-|/|.exe' | select -Last 1 -Skip 1
    if ($version -notmatch $re) { throw "Can't match version using '$re': $version" }

    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update