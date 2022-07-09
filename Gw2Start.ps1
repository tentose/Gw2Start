$Gw2Exe = "D:\Program Files (x86)\Guild Wars 2\Gw2-64.exe"
$Gw2Args = @("-autologin", "-maploadinfo")
$BHExe = "D:\BH\Blish HUD 0.11.8-ci.100\Blish HUD.exe"

$StorageDir = "$PSScriptRoot\logindat"
$AppData = "$env:AppData\Guild Wars 2"
$NewButtonName = "&New profile..."

function Get-Profile {
    Param(
        [String[]] $ProfileNames
    )
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $script:result = ""
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $True
    $form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    $form.ClientSize = New-Object System.Drawing.Size(300, 500)
    
    $table = New-Object System.Windows.Forms.TableLayoutPanel
    $table.ColumnCount = 1
    $table.Dock = [Windows.Forms.DockStyle]::Fill
    
    $form.Controls.Add($table)

    foreach ($profileName in $ProfileNames) {
        $button = New-Object System.Windows.Forms.Button
        $button.Size = New-Object System.Drawing.Size(100, 30)
        $button.Text = $profileName
        # Bottom anchor because table layout gives max space to the last row, which happens to be the "New" button that we want bottom aligned
        $button.Anchor = [Windows.Forms.AnchorStyles]::Left -bor [Windows.Forms.AnchorStyles]::Right -bor [Windows.Forms.AnchorStyles]::Bottom
        $button.Add_Click({
            $script:result = $this.Text
            $form.Close() 
        })
        $table.Controls.Add($button)
    }

    [void]$form.ShowDialog()
    $result
}

function Start-Gw2Profile {
    Param(
        [String[]] $ProfileName
    )
    Remove-Item -Recurse -Force $AppData
    New-Item -ItemType Junction -Path $AppData -Target "$StorageDir\$ProfileName"
    Start-Process -FilePath $Gw2Exe -ArgumentList $Gw2Args
    Start-Process -FilePath $BHExe
}

$profiles = Get-ChildItem -Directory -Path $StorageDir

$profileNames = @(foreach ($profile in $profiles) {
    $profile.Name
})

$profileNames += $NewButtonName

$result = Get-Profile $profileNames

Write-Host "Choice: $result"

if ($result.Length -eq 0) {
    Write-Host "No choice made"
} elseif ($result -eq $NewButtonName) {
    $profileName = Read-Host -Prompt "New profile name: "
    Copy-Item -Recurse $AppData "$StorageDir\$profileName"
    Start-Gw2Profile $profileName
} else {
    Start-Gw2Profile $result
}