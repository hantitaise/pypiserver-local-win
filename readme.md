# Pypiserver for windows

No requirement needed all packages are integrated. \
Except windows system (test on win10, win11)

how use \
```git clone https://github.com/hantitaise/pypiserver-local-win.git```

open powershel console in administrator mode

go to your directory with \
```cd {my/path/where/is}/pypiserver-local-win```

start with \
```install.ps1```

load packages 

* first edit ```download.txt``` (one by line)
  * add packages 
  * remove packages
* ```upd.packages.cmd```

to unsintall 

* ```uninstall.ps1```


### based on existing code of :

* [pypiserver](https://github.com/pypiserver/pypiserver)
* [svcbatch](https://github.com/mturk/svcbatch) 

### based on :

* [python3](https://www.python.org/) for windows 
  * test validate with 3.10.7
* [pipenv](https://github.com/pypa/pipenv)

### License

[Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0)

## Features

- [ ]  Release: installer (msi/exe) [#3](https://github.com/hantitaise/pypiserver-local-win/issues/3)
- [ ]  Powershell IIs proxy add to installation[#4](https://github.com/hantitaise/pypiserver-local-win/issues/4)
- [X]  ~~Release: zip [#2](https://github.com/hantitaise/pypiserver-local-win/issues/2)~~
