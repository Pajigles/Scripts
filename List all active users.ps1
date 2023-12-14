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

# Output user details
foreach ($result in $results) {
    $user = $result.GetDirectoryEntry()
    $accountStatus = if (($user.userAccountControl[0] -band 2) -ne 0) { "Inactive" } else { "Active" }
    $groups = ($user.memberOf | % { ([ADSI]"LDAP://$_").Name }) -join ', '

    Write-Output "User: $($user.samAccountName), Name: $($user.name), Status: $accountStatus, Groups: $groups"
}

# Clean up
$searcher.Dispose()
