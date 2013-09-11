#ids.py
#Script to append a column with ascending IDs to a CSV table
#by Daniel Petri

def main():
  inf = open('final.csv','r') #quick solution
  i=0

  newlines=[]
  for line in inf.readlines():
    print line[:-1]+","+str(i) # append ',i' at the end. Could easily do it in the front too
    i+=1

if __name__ == '__main__':
  main()