def main():
  f=open("output.txt","r")
  o=open("betterout.txt","w+")
  lines = f.readlines()
  print lines
  i=0

  for x in range(0,len(lines)/2):
    line1=lines[i][:-8]

    line2=lines[i+1]

    o.write(line1+line2)


    i+=2

if __name__ == '__main__':
  main()
