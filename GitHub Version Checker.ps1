Function Version_Check () 
    {
        #
        # Update the $Project_Author and $Project_Name variables as listed on GitHub. 
        # Update the $Local_Version variable to the correct version in the commit comments at time of build.
        #
        $Project_Author = "Scripting-Cactus"
        $Project_Name = "Github-Version-Checker"
        $Local_Version = "Version 0.0.1"
        #
        # Main Function to compare the local version of the project to the GitHub version
        #
        $Version_URL = "https://api.github.com/repos/$Project_Author/$Project_Name/commits"
        $Version_Call = Invoke-RestMethod -Uri $Version_URL
        $GitHub_Version = $Version_Call.commit.message | select-object -First 1 | Out-String 
        $Version_Commit = $Version_Call.url | select-object -First 1
        $GitHub_Version = $GitHub_Version.split("`n") | select -First 1
        $Version_Commit = $Version_Commit.split("/") | select -Last 1
        $Update_URL = "https://github.com/$Project_Author/$Project_Name/commit/$Version_Commit"
        if($GitHub_Version -eq $Local_Version)
            {
                write-host "This is the latest version of $Project_Name."   
            }
        else
            {
                write-host "There is a newer version of $Project_Name avavible on GitHub. Please go to $Update_URL to update."
            }
    }
Version_Check