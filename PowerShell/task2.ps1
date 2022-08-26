<#
   This script updates column "name" and "emails" 
   in accordance with the task
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$FileInputPath
)
process{
    $file = Get-Content -Path $FileInputPath | ConvertFrom-Csv  # Read file
    $TextInfo = (Get-Culture).TextInfo                          # Gets the current culture set in the operating system.
    foreach ($item in $file) {
        $item.email = ([string]::Concat( $item.name.Substring(0,1),
                        $item.name.Split(" ")[-1],
                        '@abc.com' )).ToLower()                 # generate new emails
        $item.name = $TextInfo.ToTitleCase($item.name)          # set first letter to uppercase
        if ({$_.email -ne $i.email}){                           # add "location_id" for equals emails
            $item.email = ([string]::Concat( $item.name.Substring(0,1),
                        $item.name.Split(" ")[-1],
                        $item.location_id,
                        '@abc.com' )).ToLower()
        }
                 
    } 
    $output_name = "accounts_new.csv"
    $file | ConvertTo-Csv -NoTypeInformation -UseQuotes AsNeeded| Set-Content -Path .\$output_name    # generate new-file use PS7
    Write-Host "Generate "$output_name "file"
}