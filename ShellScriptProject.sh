#readFile function asks the user to enter the name of the file to read the text from, then checks that is exits and that is a file not a directory for example
readFile () {
# cheacking if choice is e , if it's then the type of the text to be written is cipher else it's a plain text   
  if [ "$choice" = e ] ; then 
     textType="plain"
  else
     textType="cipher"
  fi

  while true
  do
    echo "Please enter the name of the $textType file  you would like to get the text from:"
    read fileName
    if [ ! -e "$fileName" ] 
    then
      echo "File dosn't exist!, would you like to try another name(y) or teminate (t): "
      read flag
      if [ "$flag" = "y" ]
      then 
        continue
      else 
        exit 1
      fi
	  
	else  
      if [ ! -f "$fileName" ] 
      then
        echo "It's not a file to read from!, would you like to try another name(y) or terminate (t): "
        read flag
        if [ "$flag" = "y" ]
        then 
          continue
        else 
          exit 1
        fi
      else
        echo "Reading done successfully"
        cat "$fileName" > temp1.txt
        break
	  fi
    fi
 done
 
}
#convertToLowerCase function as it names indicates it changes the alphabets to their lower case
convertToLowerCase () {
  cat temp1.txt | tr '[A-Z]' '[a-z]' > temp2.txt
  mv temp2.txt temp1.txt
}

removeNonAlphabetical () {
  sed -i 's/[^a-z ]//g' temp1.txt
  cp "temp1.txt" "temp11.txt"   
}

countFrequency(){
  #count words in the file 
  wc -w temp1.txt > temp2.txt
  #seperating each letter in a line
  sed -i 's/\(.\)/\1\n/g' temp1.txt 
  index=0
  #after having each letter printed in a line, counting the letter would be easy by counting the lines that has the letter using grep and wc
  #countOfFrequency Array has the frequency of each character, where for example the index for letter a would be 0 and so on 
  for i in {a..z}
   do
    countOfFrequency["$index"]=$(grep "$i" temp1.txt| wc -l)
    index=$((index+1))
   done
  #the last element of the countOfFrequency array is the count of words in the required file
  countOfFrequency[$index]=$(cut -d" " -f1 temp2.txt)
  #Counting the frequency of each seperate word 
  index=0
  while read line  
  do
    temp=$(printf "%d" "'$line")   #obtaining the asci value of the each seperate letter
     if [ "$temp" -ge 97 -a "$temp" -le 122 ] #checking that it is a letter, not a space or new line
    then
     temp=$((temp-97))   #to obtain the index associated with the countOfFrequency array
    # echo $temp
    sum=$((sum+${countOfFrequency["$temp"]}))
    else 
    #wordFreq array stores the frequency of each word after summing all its letters
      wordFreq["$index"]=$sum
      index=$((index+1))
      sum=0
      continue 
    fi
  done < temp1.txt
 #printing the word freq
i=0
while read line 
 do  
   temp=$(printf "%d" "'$line")
   if [ $temp -eq 0 ]   #if a zero ascii letter is reached, then we have done with this word and need to print its sum of letters frequency
   then 
    echo -n "---"
    echo "$i ${wordFreq["$i"]}"
    echo " "
    i=$((i+1))
   else                 #if a non zero letter (space) is reached, print the letters to have the word
    echo -n $line 
   fi

done < temp1.txt
}
#--------------------------------------------------------
CaculatingShiftValue(){
#we will be looping through the wordFreq array to get the maximum number 
i=1
max="${wordFreq[0]}"
for i in "${wordFreq[@]}"
 do 
  if [ "$i" -gt "$max" ]
  then 
   max="$i"
  fi
 done
echo "max is $max"
#calculating the shift value is equal to the max value mod 26
shift=$( expr $max % 26 )
echo "The shift value is $shift "
}
# Function to write a text into a file 
writeFile() {
  
  # cheacking if choice is e , if it's then the type of the text to be written is cipher else it's a plain text   
  if [ "$choice" = e ] ; then 
     textType="cipher"
  else
     textType="plain"
  fi
  
  while true 
  do
    # ask the user to enter the name of the file to write the text into 
    echo "Please enter the name of the file you would like to write the $textType text into ? "
    read fileName
	if [ -e "$fileName" ] ; then  
	   # cheaking if the given file is an ordinary file or not 
       if [ -f "$fileName" ] ; then 
          #ask the user if he want to override the file or not 
          echo "The file is already exist . Do you want to override the file ?(yes/no) " 
          read ans 
          anss=$(echo "$ans" | tr '[A-Z]' '[a-z]' )
          # if the answer is anything other than yes then exit 
          if [ $anss != yes ] ; then 
            echo "Do you want to continue and try again(y) or terminate(t) ? : "
			read flag 
			if [ $flag = y ] ; then 
               continue			
            else 
			   exit 1 
			fi
		  else
		    break 
          fi
	   else  # the given file is not an ordinary file so we can't override it or creat a file with the same name 
          echo "the fiven file is exist , but it's not an ordinary file so we can't write the text into it."
		  echo "Do you want to continue and try again(y) or terminate(t) ? : "
		  read flag 
		  if [ $flag = y ] ; then 
             continue			
          else 
       	     exit 1 
		  fi            
       fi 
	else 
      break 	
	fi
	  
  done 
  
  # write the text into the file 
  cat temp1.txt > "$fileName"
  echo "writting the text into the file done successfully "
  
}

encryption(){

  if [ "$shift" != 0 ] ; then  
    
     start=$((shift+97))
         begChar=$(printf \\$(printf "%03o" "$start"))
         end=$((start-1))
         endChar=$(printf \\$(printf "%03o" "$end"))
         cat temp11.txt | tr '[a-z]' [$begChar-za-$endChar]  > temp1.txt 
  else 
     cat temp11.txt > temp1.txt 
  fi

}

decryption(){
  if [ "$shift" != 0 ] ; then  
    
         start=$((shift+97))
         begChar=$(printf \\$(printf "%03o" "$start"))
         end=$((start-1))
         endChar=$(printf \\$(printf "%03o" "$end"))
         cat temp11.txt | tr [$begChar-za-$endChar] '[a-z]' >  temp11.txt 
  else 
         cat temp11.txt > temp1.txt   

  fi

}
echo "                     Welcome to the most GENUIS Caesar Cipher Analyzer   " 
echo "Please enter e to do encryption or d to do decryprion "
read  choice
if [ "$choice" = "E" -o "$choice" = "e" ]
then
readFile 
convertToLowerCase
removeNonAlphabetical
countFrequency
CaculatingShiftValue
encryption
writeFile
elif [ "$choice" = "D" -o "$choice" = "d" ] 
then
readFile 
#no need to convert to lower case or to remove nonalphabetical characters since it is already ciphered
countFrequency
CaculatingShiftValue
encryption
writeFile
else
echo "Not Valid!"
exit 1 
fi

