$filelist = import-csv  -Path C:\Users\vvvv\Desktop\Code\GitHub\File\file.csv  |foreach{new-item -path C:\Users\vvvv\Desktop\Code\GitHub\File -name $_.数据结构 -type directory}
#foreach ($name in  $filelist)
#{
   # new-item -path C:\Users\vvvv\Desktop\Code\GitHub\File -name $name.数据结构 -type directory
#}