# run this command to generate a 1GiB file named sample.txt: 
openssl rand -out sample.txt -base64 $(( 2**30 * 3/4 ))
# (openssl is the Secure Socket Layer library, rand option generates random bytes, -base64 makes it encoded in a format that can be read as text)
# 2**30 gets you 1GiB, and 3/4 accounts for additional bytes used for the specified base64 encoding 