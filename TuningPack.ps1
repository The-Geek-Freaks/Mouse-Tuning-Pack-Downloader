Set-ExecutionPolicy Unrestricted -Scope Process
function WriteTime {
    Param ([string]$t)
    Write-Output "$(Get-Date) $t"
}
#Tuning Pack Downloader
############################################################################################################################################################################################################
while (!(test-connection 37.120.179.48 -Count 1 -Quiet)) {
    $Verbindungbesteht = $true
    break
}
if ($Verbindungbesteht){
    $Internet = $false
} else {
    $Internet = $true
}
if ($Internet){
    WriteTime "Internetverbindung: Online"
} else {
    WriteTime "Internetverbindung: Offline"
}
##########################################################################################################################################################################

$Gedownloaded = Test-Path .\TuningPack\
if ($Gedownloaded){
    WriteTime "Das Tuning Pack wurde bereits heruntergeladen"
} else {
    if ($Internet){
        WriteTime "Das Tuning Pack muss heruntergeladen werden"
    } else {
        WriteTime "Das Tuning Pack ist nicht Installiert, jedoch besteht keine Internetverbindung. Das Programm wird beendet."
    }
}

if ($Internet){
    $NeusteVersion = Invoke-WebRequest http://root3.minerswin.de/TGF/TuningPack/LatestVersion.html -UseBasicParsing
    WriteTime "Neuste Version: $($NeusteVersion)"
    if ($Gedownloaded){
        $VersionInstalliert = Get-Content .\TuningPack\Version.txt
        if ($NeusteVersion.Content -gt $VersionInstalliert){
            WriteTime "Die aktuelle Version wird nicht mehr Unterstüzt. Die neuste wird heruntergeladen."
            WriteTime "Tuning Pack wurde beendet"
            del .\TuningPack -Recurse -Force
            WriteTime "Tuning Pack wurde gelöscht"
            $Downloadlink = curl http://root3.minerswin.de/TGF/TuningPack/DownloadLink.html -UseBasicParsing
            WriteTime "Der Download wird gestartet"
            wget $Downloadlink.Content -OutFile 'TuningPack.zip' -UseBasicParsing
            WriteTime "Der Download wurde abgeschlossen"
            Expand-Archive .\TuningPack.zip -DestinationPath .\TuningPack\
            rm TuningPack.zip
            Set-Location .\TuningPack\
            WriteTime "Das Tuning Pack wird gestartet"
            $NeusteVersion.Content | Out-File -FilePath .\Version.txt
            Start-Process powershell .\GUI.ps1
        } else {
            Set-Location .\TuningPack\
            Start-Process powershell .\GUI.ps1
        }
    } else {
        $Downloadlink = curl http://root3.minerswin.de/TGF/TuningPack/DownloadLink.html -UseBasicParsing
        WriteTime "Der Download wird gestartet"
        wget $Downloadlink.Content -OutFile 'TuningPack.zip' -UseBasicParsing
        WriteTime "Der Download wurde abgeschlossen"
        Expand-Archive .\TuningPack.zip -DestinationPath .\TuningPack\
        rm TuningPack.zip
        Set-Location .\TuningPack\
        WriteTime "Das Tuning Pack wird gestartet"
        $NeusteVersion.Content | Out-File -FilePath .\Version.txt
        Start-Process powershell .\GUI.ps1
    }
} else {
    if ($Gedownloaded){
        Set-Location .\TuningPack\
        Start-Process powershell .\GUI.ps1
    }
}
