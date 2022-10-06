function install_python {
    write-host "Python in progress"
    $cmd_python_install = "./install/python-3.10.7-amd64.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 TargetDir=c:\Python310"
    try {
        Invoke-Expression -Command $cmd_python_install | Out-String -OutVariable $cmd_python_install_result
    }
    catch {
        write-host "Python failed"
    }
}

function pipenv_install($package) {
    # install pypiserver
    $search_package = Get-ChildItem ./install/packages -Filter $package* | Select-Object -First 1 | Select name
    $cmd_pipenv_install = "pipenv run pip install ./install/packages/" + $search_package.Name + " -f ./install/packages --no-index"

    try {
        Invoke-Expression -Command $cmd_pipenv_install
    }
    catch {
        write-host $package " install error" 
    }

    write-host $package " is intalled"

}


function pip_install($package) {
    # install pypiserver
    $search_package = Get-ChildItem ./install/packages -Filter $package* | Select-Object -First 1 | Select name
    $cmd_pipenv_install = "pip install ./install/packages/" + $search_package.Name + " -f ./install/packages --no-index"

    try {
        Invoke-Expression -Command $cmd_pipenv_install
    }
    catch {
        write-host $package " install error" 
    }

    write-host $package " is intalled"

}

function create_service($bin_cmd) {
    $service_params = @{
        Name = "PyPiserver"
        BinaryPathName = $bin_cmd
        DisplayName = "PyPiserver"
        StartupType = "Automatic"
        Description = "Python Distribution de packages [server]"
      }
    
      $service_params
    New-Service @service_params 
    Get-Service PyPiserver | Where {$_.status –eq 'Stopped'} |  Start-Service
    
    
    <#
    $cmd_service_create='sc.exe create PypiServer binpath= "'+$bin_cmd+'" start=auto displayname="PypiServer" '
    # create windows service #local Python packages udpates
    write-host $cmd_service_create
    try {
        Invoke-Expression -Command $cmd_service_create
    }
    catch {
        write-host "Error Install service"
        Write-Host $_.ScriptStackTrace
    }

    #>
    
}

# check python version
try {
    Invoke-Expression -Command "python --version"
}
catch {
    install_python
}

write-host "result" $Python_version
if ($Python_version -eq "") {
    write-host "need install python"
    install_python
}

write-host "Python is intalled"

$path_venv = ".\.venv"
If (!(test-path -PathType container $path_venv)) {
    New-Item -ItemType Directory -Path $path_venv
}

$path_packages = ".\packages"
If (!(test-path -PathType container $path_packages)) {
    New-Item -ItemType Directory -Path $path_packages
}

$path_logs = ".\Logs"
If (!(test-path -PathType container $path_logs)) {
    New-Item -ItemType Directory -Path $path_logs
}

#update package install
./upd.install.packages.cmd

# install pipenv
pip_install("pipenv")

# install inside venv
pipenv_install("pypiserver")
#pipenv_install("hypercorn")


$Port = 8080
$Port_ok = $false

while ( $Port_ok -eq $false) {
    $check_port = Test-NetConnection -ComputerName localhost -Port $Port
    
    if ($check_port.TcpTestSucceeded) { 
        write-host "Port not available "+$Port
        $Port += 1
    }
    else {
        $Port_ok = $true
    }

    

}

write-host "Port available " $Port

$Port_Q = 'Server installation on Port ? [' + $Port + '] '
$Port_user = Read-Host -Prompt $Port_Q

if ($Port_user -ne '') {
    $Port = $Port_user
}


write-host "Installation port :" $Port

$cmd_run_server+="pipenv run pypi-server run -p " + $Port + " "+$pwd.path+"\packages\"
Set-Content -Path .\run.cmd -Value $cmd_run_server
$bin_cmd='"'+$pwd.path+'\svcbatch.exe" run.cmd'


create_service($bin_cmd)



Get-Service PyPiserver

#sc.exe delete PypiServer
