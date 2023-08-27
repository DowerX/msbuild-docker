$env:VS_VERSION=17

Write-Host -NoNewLine "Cleaning up... "
mkdir "C:\msbuild"
rm -r -force "\\10.0.2.4\qemu\msbuild"
rm -r -force "\\10.0.2.4\qemu\inno5"
Write-Host "Done."

Write-Host -NoNewLine "Installing Inno Setup 5... "
Start-Process -FilePath "\\10.0.2.4\qemu\innosetup-5.6.1.exe" -ArgumentList "/SP- /SILENT /NORESTART /NOCANCEL /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS /NORESTARTAPPLICATIONS /NOICONS /DIR=C:\inno5" -Wait
Write-Host "Done."

Write-Host -NoNewLine "Installing Windows SDK... "
Start-Process -FilePath "\\10.0.2.4\qemu\winsdksetup.exe" -ArgumentList "/norestart /quiet /ceip off /installpath C:\msbuild\winsdk" -Wait
while (Get-Process -Name winsdksetup -ErrorAction SilentlyContinue) {
    Start-Sleep -Seconds 5
}
Write-Host "Done."

Write-Host -NoNewLine "Installing VisualStudio BuildTools... "
Start-Process -FilePath "\\10.0.2.4\qemu\vs_BuildTools.exe" -ArgumentList "--channelURI https://aka.ms/vs/$env:VS_VERSION/release/channel --nocache --noUpdateInstaller --installPath C:\msbuild\vs_buildtools --addProductLang en-US --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.ATLMFC --includeRecommended --wait --quiet" -Wait
Write-Host "Done."

Write-Host -NoNewLine "Copying... "
Copy-Item -Path "C:\msbuild" -Destination "\\10.0.2.4\qemu\" -Recurse
Copy-Item -Path "C:\inno5" -Destination "\\10.0.2.4\qemu\" -Recurse
Write-Host "Done."