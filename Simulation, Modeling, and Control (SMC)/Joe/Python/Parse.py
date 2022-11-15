import re
import pandas

with open('test.txt') as file:
    
    fp= file.read()
    #print(fp)
    fp = fp.split('\n')
    #print(fp)
    data = []
    for line in fp:
        #print(line)
        line = line.split(" ")

        print(line)
        for index, val in enumerate(line):
            print(index,val)
            if val == 'X:':
                data.append(line[index + 1]) 
                
    print(data)
            
        
        