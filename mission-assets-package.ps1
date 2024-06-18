$rootPath = Get-Location
$tempDistDirectory = Join-Path $rootPath -ChildPath "_tempDist"

$buildMissionBackend = {
    $missionBackendProject = ".\WebApiDocker\WebApi\WebApi.csproj"
    $missionBackendProjectName = "MissionAppWebApi"        
    
    $buildOutputDir = Join-Path $tempDistDirectory -ChildPath $missionBackendProjectName 
    Write-Host Start building Mission backend project
    dotnet build $missionBackendProject --configuration Release -o $buildOutputDir
}

$buildVideoConvertorService = {
    $videoConvertorOutputDirectory = ".\dist"
    $videoConvertorProject = ".\nodejsBackend"
    $videoConvertorProjectName = "VideoConvertor"        
    
    $buildOutputDir = Join-Path $tempDistDirectory -ChildPath $videoConvertorProjectName 
    $originalDirectory = Get-Location
    Set-Location -Path $videoConvertorProject
    npm install && npm run build
    Copy-Item -Path $videoConvertorOutputDirectory -Destination $buildOutputDir -Recurse -Force
    Set-Location $originalDirectory
}

$buildMissionWebApp = {
    $missionFrontendOutputDirectory = ".\dist"
    $missionFrontendProject = ".\mission-web-app"
    $missionFrontendProjectName = "MissionWebApp"        
    
    $buildOutputDir = Join-Path $tempDistDirectory -ChildPath $missionFrontendProjectName 
    $originalDirectory = Get-Location
    Set-Location -Path $missionFrontendProject
    npm install && npm run build
    Copy-Item -Path $missionFrontendOutputDirectory -Destination $buildOutputDir -Recurse -Force
    Set-Location $originalDirectory
}

$CreateMissionAssetsTarFile = {
    $OutputTarPath = ".\mission-assets.tar"
    
    if (Test-Path -Path $OutputTarPath) { Remove-Item -Path $OutputTarPath -Force }
    tar -cvf $OutputTarPath -C $tempDistDirectory .
    Write-Host "The directory $tempDistDirectory has been archived into $OutputTarPath."

    Remove-Item -Path $tempDistDirectory -Recurse -Force
}

Invoke-Command $buildMissionBackend
Invoke-Command $buildVideoConvertorService
Invoke-Command $buildMissionWebApp
Invoke-Command $CreateMissionAssetsTarFile