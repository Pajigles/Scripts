# Enumerate members of local Administrators group on other machines
$LocalGroup = 'Administrators'
$pdc=[System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner;
$dn=([adsi]'').distinguishedName
$p=("LDAP://"+$pdc.Name+"/"+$dn);
$d=New-Object System.DirectoryServices.DirectoryEntry($p)
$s=New-Object System.DirectoryServices.DirectorySearcher($d)
$s.filter="(objectCategory=computer)"
$computers=$s.FindAll()|%{$_.Properties.cn}
foreach ($c in $computers) {
  echo "`r`n==========   $c   =========="
  try {
    $grp=[ADSI]("WinNT://$c/$LocalGroup,Group")
    $mbrs=$grp.PSBase.Invoke('Members')
    $mbrs.Foreach{$_.GetType().InvokeMember('Name','GetProperty',$null,$_,$null)}
  } catch {
    echo "[x] ERROR retrieving group members"
    continue
  }
}
