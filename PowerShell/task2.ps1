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
    [array]$AllEmails = @('')
    Write-Host "$file"
    foreach ($item in $file) {
        $item.email = ([string]::Concat( $item.name.Substring(0,1),
                        $item.name.Split(" ")[-1],
                        '@abc.com' )).ToLower()                 # generate new emails
        $item.name = $TextInfo.ToTitleCase($item.name)          # set first letter to uppercase
       
        $AllEmails += $item.email             
    }
    #Find emails with dublicates
    $EqualEmails =($AllEmails | Group-Object | Sort-Object -Property "Count" |
         Where-Object Count -GT 1 | ForEach-Object -Proces{Write-Output $($_.name)})     
    #Add location_id for equal emails
    foreach ($item in $file) {
        if ($item.email -in $EqualEmails){  
            $item.email = ([string]::Concat( $item.name.Substring(0,1),
                        $item.name.Split(" ")[-1],
                        $item.location_id,
                        '@abc.com' )).ToLower()
    }
   }
    $output_name = "accounts_new.csv"
    $file | ConvertTo-Csv -NoTypeInformation -UseQuotes AsNeeded | Set-Content -Path .\$output_name    # generate new-file
    Write-Host "Generate "$output_name "file"  
} 
