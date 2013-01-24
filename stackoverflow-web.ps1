# exto-posh-web for stackoverflow
# Init by extofer 
#
# like a text web browser
# use this cmdlet to list results of 
# stackoverflow search and select the 
# Q&A to read text only
#
# BSD New License  
# https://raw.github.com/extofer/exto-posh-web/master/LICENSE


$arg= $args[0]
cls
$arg  = $arg -replace " ","+"
   Write-Host $step
$count = 0
$search = Invoke-WebRequest "http://stackoverflow.com/search?q=$arg"

# filters link results to "questions" only
$results = $search.links | where href -like "*/questions/*"  



# list all results to key word searched
foreach ($result in $results)
{
  $count += 1 
    
    # excluded the tag links
    if ($result.href -notlike "*/questions/tagged*")
    {
        Write-Host [$count]  -foregroundcolor DarkMagenta
        Write-Host $result.InnerText  
    }


}

$getlink = Read-Host "Select the linkt you want to view" 

[int]$i = $getlink-1

# gets content of the selected post
$var = $results[$i].href

Write-Host You selected $results[$i].InnerText uri $var  -foregroundcolor DarkMagenta 


$data = Invoke-WebRequest "http://stackoverflow.com$var"
Write-Host ******************************** Posted Question ********************************  -foregroundcolor DarkMagenta 
# write the posted question
$data.ParsedHtml.getElementsByTagName("div") |  Where "id" -match "question-header" | Select -ExpandProperty InnerText  
$data.ParsedHtml.getElementsByTagName("div") |  Where "classname" -match "^question" | Select -ExpandProperty InnerText  

Write-Host ******************************** Posted Answer ********************************  -foregroundcolor DarkMagenta 

# write the posted accepted-answer first
$data.ParsedHtml.getElementsByTagName("div") |  Where "classname" -match "answer accepted-answer" | Select -ExpandProperty InnerText  

# write the posted all other answers
$data.ParsedHtml.getElementsByTagName("div") |  Where "classname" -match "answer" | Select -ExpandProperty InnerText  