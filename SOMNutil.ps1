$AutomaticVars = Get-Variable
$AutomaticFunctions=get-command -CommandType Function 
function myVars {Compare-Object (Get-Variable) $AutomaticVars -Property Name -PassThru | Where -Property Name -ne "AutomaticVars"}
function myFunctions {Compare-Object (get-command -CommandType Function) $AutomaticFunctions -Property Name -PassThru | Where -Property Name -ne "AutomaticFunctions"}

<#
.Synopsis
   Change title bar in current PoSH console
.DESCRIPTION
   Changes the title bar in the current console by appending " - " and the <string> to existing title <OR> replacing the title bar with <string>.
   Will attempt to center the new title by default.
.EXAMPLE
   Set-TabTitleBar "I want this added to the Title" 

   Will add the text "I want this added to the Title" with preceding hypen to the current title 

.EXAMPLE
   Set-TabTitleBar "I want this to be the only thing on the Title" -replace

   Replaces the title bar with the text "I want this to be the only thing on the Title"

.INPUTS   
.OUTPUTS
.NOTES
    TitleBar length is not quite equal to window width.  How much length taken depends on characters used.
    You can see this by doing the following where both strings are 'windowWidth' length chars but title bar is different.
    The additional 5% is arbitrary to attempt to center the title.

    $x=$Null
    $host.ui.RawUI.WindowSize.Width
    1..$host.ui.RawUI.WindowSize.Width|%{$x+='X'}
    $host.ui.RawUI.WindowTitle=$x
    $x.Length

    $x=$Null
    $host.ui.RawUI.WindowSize.Width
    1..$host.ui.RawUI.WindowSize.Width|%{$x+='-'}
    $host.ui.RawUI.WindowTitle=$x
    $x.Length
#>
function Set-TABTitleBar
{
    [CmdletBinding()]
    [Alias('SetTitleBar','UpdateTitleBar')]
    [OutputType()]
    Param
    (        
        [string][Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $newTitle,             
        [switch] [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        $replace,
        [switch] [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        $centerTitle = $true
    )
    Begin {$origTitle = $host.ui.RawUI.WindowTitle;$startPosition=0}
    Process{
        $tmpTitle="*** $newTitle ***"        
        If(!$replace){$tmpTitle=$origTitle,"$tmpTitle" -join " - "}
            
        If($centerTitle){
                #the 5% additional is arbitrary. TitleBar length is not equal to window width. It also depends on characters used
                $startPosition=($host.ui.RawUI.WindowSize.Width-$tmpTitle.Length)*1.05                
                1..$startPosition|%{$spaceTitle+=' '}
                $tmpTitle=$spaceTitle,$tmpTitle -join ''                
                }                
        $host.ui.RawUI.WindowTitle = $tmpTitle                       
        }    
    End{}
}