# powershell -ep bypass

# Name the file function.ps1

# PS C:\Users\stephanie> Import-Module .\function.ps1

# Enum on specific samAccountType
# PS C:\Users\stephanie> LDAPSearch -LDAPQuery "(samAccountType=805306368)"

# List all groups in the domain
# PS C:\Users\stephanie> LDAPSearch -LDAPQuery "(objectclass=group)"

function LDAPSearch {
    param (
        [string]$LDAPQuery
    )

    $PDC = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.Name
    $DistinguishedName = ([adsi]'').distinguishedName

    $DirectoryEntry = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$PDC/$DistinguishedName")

    $DirectorySearcher = New-Object System.DirectoryServices.DirectorySearcher($DirectoryEntry, $LDAPQuery)

    return $DirectorySearcher.FindAll()

}
