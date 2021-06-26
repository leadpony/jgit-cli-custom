$scriptPath = $MyInvocation.MyCommand.Path
$baseDir = Split-Path $scriptPath -Parent

$cmd = $null
foreach ($arg in $args) {
    if (-not $arg.StartsWith('-')) {
        $cmd = $arg
        break
    }    
}

$usePager = @('blame', 'diff', 'log').Contains($cmd)

$java = "java"
if ($null -ne $env:JAVA_HOME) {
    $java = "$env:JAVA_HOME\bin\java"
}

$javaArgs = @('-jar', "$baseDir\jgit-cli-${jgit.version}.jar") + $args
$javaArgs = $javaArgs | ForEach-Object { """$_""" } 

$encoding = [Console]::OutputEncoding
try {
    [Console]::OutputEncoding = [Text.Encoding]::UTF8
    $Host.UI.RawUI.FlushInputBuffer()
    if ($usePager) {
        & $java $javaArgs | Out-Host -Paging
    } else {
        & $java $javaArgs
    }
} catch [System.Management.Automation.HaltCommandException] {
    Write-Host $_
} finally {
    [Console]::OutputEncoding = $encoding
}
