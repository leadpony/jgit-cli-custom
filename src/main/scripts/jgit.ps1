$scriptPath = $MyInvocation.MyCommand.Path
$baseDir = Split-Path $scriptPath -Parent

$java = "java"
if ($null -ne $env:JAVA_HOME) {
    $java = "$env:JAVA_HOME\bin\java"
}

$javaArgs = @('-jar', "$baseDir\jgit-cli-${jgit.version}.jar") + $Args
$javaArgs = $javaArgs | ForEach-Object { """$_""" } 

Start-Process -FilePath $java -ArgumentList $javaArgs -Wait -NoNewWindow
