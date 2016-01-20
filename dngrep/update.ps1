. ../au.ps1

$releases = 'https://github.com/dnGrep/dnGrep/releases'

function au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')" = "`$1'$($Latest.URL64)'"
            "(^[$]url32\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
        }
     }
}

function au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases
    $url      = $download_page.links | ? href -match 'dnGREP.*.msi' | select -First 2 -expand href
    $version  = ($url[0] -split '\/' | select -Index 5).Substring(1)

    $url64    = 'https://github.com' + $url[0]
    $url32    = 'https://github.com' + $url[1]

    $Latest = @{ URL64 = $url64; URL32 = $url32; Version = $version }
    return $Latest
}

update
