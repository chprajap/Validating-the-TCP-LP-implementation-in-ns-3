import os
import sys
import numpy as np

#start_time = int (sys.argv[1])
#end_time = int (sys.argv[2])
#interval = float (sys.argv[3])

def get_sockets(in_filepath):
  all_sockets = []
  curr_socket = []
  first_socket = 1
  with open(in_filepath) as in_file:
    for line in in_file:
      if "ss -a -e -i" in line:
        if first_socket:
          first_socket = 0
        else:
          all_sockets.append(curr_socket)
          curr_socket = []
      else:
        if not first_socket:
          curr_socket.append(line)
		
  all_sockets.append(curr_socket)
  return all_sockets

sender_node_id = range (2, 7)
receiver_node_id = range (7, 12)

if (not os.path.isdir("../results/gfc-dumbbell/cwnd_data")):
  os.system("mkdir ../results/gfc-dumbbell/cwnd_data")

for i in sender_node_id:
  os.system ("cat ../files-"+str(i)+"/var/log/*/* > "+"../results/gfc-dumbbell/cwnd_data/"+str(i))

for i in sender_node_id:
  in_filepath = "../results/gfc-dumbbell/cwnd_data/"+str(i)
  all_sockets = get_sockets(in_filepath)
  write_mode = 'w'
  for socket in all_sockets:
    time_found = 0
    cwnd_found = 0
    port_found = 0
    time = None
    cwnd = None
    for info in socket:
      if "NS3" in info:
        time = info.split("NS3 Time:")[1].split(',')[0].strip().split('(')[1].strip().strip(')').strip().strip('+').strip('ns')
        time_format = float(time)/1000000000
        time_found = 1
      if ":50000" in info:
        port = 50000
        port_found = 1
			
      if "cwnd" in info:
        cwnd = info.split("cwnd:")[1].split()[0]
        if port_found:
          with open("../results/gfc-dumbbell/cwnd_data/"+str(i) + "_format.txt", write_mode) as out_file:
            out_file.write(str(time_format) + "," + str(cwnd) + "\n")
          write_mode = 'a'
          port_found = 0


'''
  time = np.arange (float (start_time), float (end_time), interval)
  cwnd_data = []
  with open ("../results/gfc-dumbbell/cwnd_data/"+str(i)) as f:
    for line in f:
      j = 0
      m = line.find ("cwnd")
      if (m == -1):
        continue
      for k in range (m, len (line)):
         if (ord(line[k]) >= 48 and ord (line[k]) <= 57):
           j = k
           break
      cwnd = ""
      for o in range (j, len (line)):
        if (ord (line[o]) < 48 or ord (line[o]) > 58):
          break;
        cwnd+=str (line [o])
      cwnd_data.append (cwnd)
  f.close ()
  format_data_file = open ("../results/gfc-dumbbell/cwnd_data/"+str(i)+"_format.txt", "w+")
  print_val = min (len (cwnd_data), len (time))
  pop_val = len (time) - print_val
  for k in range(pop_val):
    time = np.delete (time, 0)
  for z in range(len (cwnd_data)):
    format_data_file.write (str(time[z])+","+cwnd_data[z]+"\n")
'''  
