# Define LDAP path for your domain
$domain = "DC=yourdomain,DC=com"  # Replace with your domain components

# Create a DirectorySearcher object
$searcher = New-Object DirectoryServices.DirectorySearcher
$searcher.SearchRoot = New-Object DirectoryServices.DirectoryEntry("LDAP://$domain")

# Define the LDAP query filter to search for all users
$searcher.Filter = "(&(objectCategory=person)(objectClass=user))"

# Specify which properties to load
$searcher.PropertiesToLoad.Add("samAccountName") > $null
$searcher.PropertiesToLoad.Add("name") > $null
$searcher.PropertiesToLoad.Add("userAccountControl") > $null
$searcher.PropertiesToLoad.Add("memberOf") > $null

# Search and collect results
$results = $searcher.FindAll()

# Initialize an array to hold the data
$userData = @()

# Process each result
foreach ($result in $results) {
    $user = $result.GetDirectoryEntry()
    $accountStatus = if (($user.userAccountControl[0] -band 2) -ne 0) { "Inactive" } else { "Active" }
    $groups = ($user.memberOf | % { ([ADSI]"LDAP://$_").Name }) -join ', '

    # Create a custom object for each user
    $obj = New-Object PSObject -Property @{
        SamAccountName = $user.samAccountName[0]
        Name = $user.name[0]
        Status = $accountStatus
        Groups = $groups
    }

    # Add the object to the array
    $userData += $obj
}

# Export the array to a CSV file
$outputPath = "C:\\path\\to\\output\\users.csv"  # Specify the output file path
$userData | Export-Csv -Path $outputPath -NoTypeInformation

Write-Output "Data exported to $outputPath"
