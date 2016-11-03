#
# Author: Scripting-Cactus
# Note: Unauthenticated requests to GitHub are limited to 60 Requests per hour based on IP address
#
#
# Update the $Project_Author and $Project_Name variables as listed on GitHub. 
# Update the $Local_Version variable to the correct version in the commit comments at time of build.
#
$Project_Author = "Scripting-Cactus"
$Project_Name = "Github-Version-Checker"
$Local_Version = "Version 0.0.2"
Function Version_Check () 
    {
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
Function Version_Check_WPF () 
    {
        [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
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
                $Version_Title = "No Updates Availble for $Project_Name"
                $Version_Message = "This is the latest version."
                $Update_URL = ""   
            }
        else
            {
                $Version_Title = "Update Avavilble for $Project_Name"
                $Version_Message = "To update, please go to:"
            }
        #
        # Form Population
        #
        $Version_XML = @"
<Window x:Class="WpfApplication1.Version_Window"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    xmlns:local="clr-namespace:WpfApplication1"
    mc:Ignorable="d"
    Title="Version Check" Height="160" Width="400" WindowStartupLocation="CenterScreen" ResizeMode="NoResize" Background="White" Visibility="Visible">
    <Grid Margin="0">
        <TextBlock x:Name="Version_Text_Title" HorizontalAlignment="Left" Margin="5,5,10,5" TextWrapping="Wrap" VerticalAlignment="Top" Width="380" Height="18">
            <Bold>$Version_Title</Bold>
        </TextBlock>
        <TextBlock x:Name="Version_Text_Message" HorizontalAlignment="Left" Margin="5,25,10,5" TextWrapping="Wrap" VerticalAlignment="Top" Width="380" Height="18">
            $Version_Message
        </TextBlock>
        <TextBox x:Name="Version_TextBox" BorderThickness="0" HorizontalAlignment="Left" Height="60" Margin="5,50,5,5" VerticalAlignment="Top" Width="380" TextWrapping="Wrap" IsReadOnly="True" />
        <Button x:Name="Version_OK_Button" Content="OK" HorizontalAlignment="Left" Margin="162.5,99,0,0" VerticalAlignment="Top" Width="75" Height="26"/>
    </Grid>
</Window>
"@      
        $Version_XML = $Version_XML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
        [xml]$Version_xaml = $Version_XML
        $Version_reader=(New-Object System.Xml.XmlNodeReader $Version_xaml)
        try
            {
                $Version_Form = [Windows.Markup.XamlReader]::Load($Version_reader)
            }
        catch
            {
                Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."
            }
        $Version_xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF_$($_.Name)" -Value $Version_Form.FindName($_.Name)}
        $WPF_Version_TextBox.Text = $Update_URL
        $WPF_Version_OK_Button.Add_Click({$Version_Form.Close()})
        $Version_Form.ShowDialog() | out-null
    }
Version_Check
Version_Check_WPF