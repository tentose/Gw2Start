# Gw2Start
Powershell launcher for Guild Wars 2

# Usage
1. Clone (or download a copy of `Gw2Start.ps1` and put it in its dedicated folder). The script will be writing to the directory where it's placed.
2. Modify your copy of `Gw2Start.ps1` to point to your `Gw2-64.exe` and `Blish HUD.exe`:
   ```
   $Gw2Exe = "D:\Program Files (x86)\Guild Wars 2\Gw2-64.exe"
   $Gw2Args = @("-autologin", "-maploadinfo")
   $BHExe = "D:\BH\Blish HUD 0.11.8-ci.100\Blish HUD.exe"
   ```
3. Right click `Gw2Start.ps1` and run the script. It will create a shortcut in the same folder that you can double click to run the script later.
4. Create a new profile by clicking on **New profile...**. Give it a name in the console window.
5. GW2 will start. Cancel the autologin if necessary. Enter the account information for this profile.

Repeat steps 4 and 5 for any alts you have. 
