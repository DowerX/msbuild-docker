mkdir C:\msbuild

$env:VS_VERSION=17

echo "Installing VisualStudio BuildTools..."
Start-Process -FilePath "\\10.0.2.4\qemu\vs_BuildTools.exe" -ArgumentList "--channelURI https://aka.ms/vs/$env:VS_VERSION/release/channel --nocache --noUpdateInstaller --installPath C:\msbuild\vs_buildtools --addProductLang en-US --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.ATLMFC --includeRecommended --wait --quiet" -Wait

echo "Installing Windows SDK..."
Start-Process -FilePath "\\10.0.2.4\qemu\winsdksetup.exe" -ArgumentList "/norestart /q /installpath C:\msbuild\winsdk" -Wait

echo "Copying..."
Copy-Item -Path C:\msbuild -Destination \\10.0.2.4\qemu\ -Recurse

echo "Done!"