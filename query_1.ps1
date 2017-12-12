#****************************************\
#* Catalog Crawler (CCv1.0b)
#* Pulls Data From database containing
#* a wildcard and enumerates through
#*
#****************************************/

# MySQL Connect
$connectionString = "Server=vlamp01;port=3306;Uid=db_admin;Pwd=@Panzer70;database=vortex_vgi;"
$Query = "SELECT * FROM datastores"

$results = mysql-query -ConnectionString $connectionString  -Query $Query

#Start-Job -ScriptBlock {

$locs = @('\\prdvsan\vfs\Torrents\UTF1\Completed\','\\prdvsan\vfs\Torrents\UTF2\completed\','\\prdvsan\vfs\Torrents\UTF3\Completed\','Q:\utorrent_temp\completed\')
#########
$des  = "\\prdvsan\vfs\Media\Television Series\TVS05\Legends\Season 2"
$card = "*Legend*"

foreach($l in $locs){

    $fstring = $l + $card
    $results = Get-ChildItem $fstring
    $des_delete_path = $l + '\' + 'to-be-deleted'
    foreach($rs in $results)
    {
        $SPath = $rs.FullName
        $sname = $rs.Name
        if($rs.PSIsContainer)
        {
            $des_parent_path = $des + '\' + $rs.Name
            #robocopy.exe $SPath $des_parent_path /MIR /MT
            Move-Item -Path $SPath -Destination $des_delete_path

        }
        else
        {   
            #robocopy.exe $l $des $rs.Name $sname
            Move-Item -Path $l -Destination $des_delete_path
        }
        
    }
}

#}