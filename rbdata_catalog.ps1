<#
---0-| Name: Garvey Snow
---0-| Description:  RoboCopy Automation script - pulls data from mysql or csv and catalogs 
                     data base upon wildcard strings pulled from CSV or MySQL Database
---0-| Dependancies: • https://github.com/adbertram/MySQL/blob/master/MySQL.psm1
                     • MYSQL Client DLL
---0-| Version: 1.2a
#>

New-PSDrive -PSProvider FileSystem -Name sc_root -Root 'I:\Homelab-documents\Projects\Powershell Catalog Script'
$csv_data = Import-Csv 'sc_root:\catalog.csv'

foreach($catdata in $csv_data){
    


    #### VARS ####
    $category_id       = $catdata.category_id
    $worker_id         = $catdata.worker_id
    $category_name     = $catdata.category_name
    $catagory_dpath    = $catdata.category_dpath
    $category_wildcard = $catdata.category_wildcard
    ##############
    $des  = $catagory_dpath
    $card = "*" + $category_wildcard + "*"
    # ========================
    Start-Job -Name $category_name -ScriptBlock { 
        $des      = $args[0];
        $wildcard = $args[1];
        $locs = @(
                  '\\prdvsan\vfs\Torrents\UTF1\Completed\',
                  '\\prdvsan\vfs\Torrents\UTF2\completed\',
                  '\\prdvsan\vfs\Torrents\UTF3\Completed\',
                  '\\ws001\q$\utorrent_temp\completed\'
                 )
        foreach($l in $locs)
                {
                    $fstring = $l + $wildcard
                    $results = Get-ChildItem $fstring
                    $des_delete_path = $l + '\' + 'to-be-deleted'
                    if(Test-Path $des_delete_path){}else{mkdir $des_delete_path}
                    foreach($rs in $results)
                    {
                        $SPath = $rs.FullName
                        $sname = $rs.Name
                        if($rs.PSIsContainer)
                        {
                            $des_parent_path = $des + '\' + $rs.Name
                            robocopy.exe $SPath $des_parent_path /MIR /MT /MOVE
                        }
                        else
                        {   
                            robocopy.exe $l $des $rs.Name $sname /MOV
                        }
        
                        }
                 }# endforach
    
        } -ArgumentList $catagory_dpath,$card
        # ========================

} #end foreach

# clean-up
Remove-PSDrive -Name sc_root