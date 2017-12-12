function robodata()
{
    param($SPath,$sname)

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
