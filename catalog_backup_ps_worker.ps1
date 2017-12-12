New-PSDrive -PSProvider FileSystem -Name sc_root -Root '\\prdvsan\vfs\Documents\Homelab-Documents\Projects\Powershell Catalog Script'
$csv_data = Import-Csv 'sc_root:\catalog.csv'

foreach($catdata in $csv_data){
    
    #### VARS ####
    $category_id       = $catdata.category_id
    $worker_id         = $catdata.worker_id
    $category_name     = $catdata.category_name
    $catagory_dpath    = $catdata.category_dpath
    $category_wildcard = $catdata.category_wildcard
    ##############

   # Start-Job -ScriptBlock {
        $locs = @(
                    '\\prdvsan\vfs\Torrents\UTF1\Completed\',
                    '\\prdvsan\vfs\Torrents\UTF2\completed\',
                    '\\prdvsan\vfs\Torrents\UTF3\Completed\',
                    '\\ws001\q$\utorrent_temp\completed'
                 )
        ######
        #
        ######
        $des  = $catagory_dpath
        $card = "*" + $category_wildcard + "*"

        #####################################

        foreach($l in $locs){

            $fstring = $l + $card
            $results = Get-ChildItem $fstring

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
        }

        ####################################

   # } 

}

# clean-up
Remove-PSDrive -Name sc_root