#! /bin/bash

#generating keys and naming it ansible 
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ansible

#check if the file path passed as a parameter
if [ -z "$1" ]; then
	echo "please provide a file"
	exit 1
fi

#save the file in file variable
file="$1"

#check if the file path exist
if [ ! -f "$file" ]; then
	echo "The file not found!"
	exit 1
fi

#number of lines == number of users i want to ssh into it
#By redirecting the input with < "$file", you avoid having wc output the filename along with the line count. 
#number_lines=$(wc -l < "$file")

#while loop for each line of the file as each line contain one user:host
while IFS= read -r line; do
	echo "$line"
	#/:/@/g is a sed expression that replaces every occurrence of : with @ on each line. The g at the end stands for "global," meaning all occurrences of : will be replaced, not just the first one.
	modified_line=$(echo "$line" | sed 's/:/@/g')
	#gsub(/:/, "@") is an awk function that globally substitutes all colons (:) with the at symbol (@) in each line.
	#modified_line=$(echo "$line" | awk '{gsub(/:/, "@"); print}')
	echo "Modified line: $modified_line"
	echo "$modified_line" >> new_hosts.txt
    
    	# Copy the SSH public key to the remote server (user@host)
    	ssh-copy-id -i ~/.ssh/ansible.pub "$modified_line"
done < "$file"

# After copying the keys, SSH into the first user/host combination
first_line=$(head -n 1 "$file")
modified_first_line=$(echo "$first_line" | sed 's/:/@/g')

# SSH into the first user@host
echo "SSH into the first user@host: $modified_first_line"
ssh "$modified_first_line"
