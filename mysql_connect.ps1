﻿Function MySQLQuery {
<#
.SYNOPSIS
   run-MySQLQuery
    
.DESCRIPTION
   By default, this script will:
    - Will open a MySQL Connection
	- Will Send a Command to a MySQL Server
	- Will close the MySQL Connection
	This function uses the MySQL .NET Connector or MySQL.Data.dll file
     
.PARAMETER ConnectionString
    Adds the MySQL Connection String for the specific MySQL Server
     
.PARAMETER Query
 
    The MySQL Query which should be send to the MySQL Server
	
.EXAMPLE
    C:\PS> run-MySQLQuery -ConnectionString "Server=localhost;Uid=root;Pwd=p@ssword;database=project;" -Query "SELECT * FROM firsttest" 
    
    Description
    -----------
    This command run the MySQL Query "SELECT * FROM firsttest" 
	to the MySQL Server "localhost" with the Credentials User: Root and password: p@ssword and selects the database project
         
.EXAMPLE
    C:\PS> run-MySQLQuery -ConnectionString "Server=localhost;Uid=root;Pwd=p@ssword;database=project;" -Query "UPDATE firsttest SET firstname='Thomas' WHERE Firstname like 'PAUL'" 
    
    Description
    -----------
    This command run the MySQL Query "UPDATE project.firsttest SET firstname='Thomas' WHERE Firstname like 'PAUL'" 
	to the MySQL Server "localhost" with the Credentials User: Root and password: p@ssword
	
.EXAMPLE
    C:\PS> run-MySQLQuery -ConnectionString "Server=localhost;Uid=root;Pwd=p@ssword;" -Query "UPDATE project.firsttest SET firstname='Thomas' WHERE Firstname like 'PAUL'" 
    
    Description
    -----------
    This command run the MySQL Query "UPDATE project.firsttest SET firstname='Thomas' WHERE Firstname like 'PAUL'" 
	to the MySQL Server "localhost" with the Credentials User: Root and password: p@ssword and selects the database project
    
#>
	Param(
        [Parameter(
            Mandatory = $true,
            ParameterSetName = '',
            ValueFromPipeline = $true)]
            [string]$query,   
		[Parameter(
            Mandatory = $true,
            ParameterSetName = '',
            ValueFromPipeline = $true)]
            [string]$connectionString
        )
	Begin {
		Write-Verbose "Starting Begin Section"		
    }
	Process {
		Write-Verbose "Starting Process Section"
		try {
			# load MySQL driver and create connection
			Write-Verbose "Create Database Connection"
			# You could also could use a direct Link to the DLL File
			$mySQLDataDLL = "C:\Program Files (x86)\MySQL\MySQL Connector Net 6.9.8\Assemblies\v4.5\MySQL.Data.dll"
			[void][system.reflection.Assembly]::LoadFrom($mySQLDataDLL)
			[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
			$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
			$connection.ConnectionString = $ConnectionString
			Write-Verbose "Open Database Connection"
			$connection.Open()
			
			# Run MySQL Querys
			Write-Verbose "Run MySQL Querys"
			$command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
			$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
			$dataSet = New-Object System.Data.DataSet
			$recordCount = $dataAdapter.Fill($dataSet, "data")
			$dataSet.Tables["data"] | Format-Table
		}		
		catch {
			Write-Host "Could not run MySQL Query" $Error[0]	
		}	
		Finally {
			Write-Verbose "Close Connection"
			$connection.Close()
		}
    }
	End {
		Write-Verbose "Starting End Section"
	}
}